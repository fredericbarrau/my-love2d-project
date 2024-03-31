/*
Copyright 2024.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

package controller

import (
	"context"

	"k8s.io/apimachinery/pkg/runtime"
	ctrl "sigs.k8s.io/controller-runtime"

	"sigs.k8s.io/controller-runtime/pkg/log"

	gamesv1alpha1 "github.com/fredericbarrau/pong-made-with-love.git/api/v1alpha1"
	corev1 "k8s.io/api/core/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"

	appsv1 "k8s.io/api/apps/v1"
	"k8s.io/apimachinery/pkg/util/intstr"
	"sigs.k8s.io/controller-runtime/pkg/client"
)

// PongReconciler reconciles a Pong object
type PongReconciler struct {
	client.Client
	Scheme *runtime.Scheme
}

var default_pong_image = "pong:0.0.1" // TODO: this should be the default image for the pong application defined in the webhook

//+kubebuilder:rbac:groups=games.fredericbarrau.bzh,resources=pongs,verbs=get;list;watch;create;update;patch;delete
//+kubebuilder:rbac:groups=games.fredericbarrau.bzh,resources=pongs/status,verbs=get;update;patch
//+kubebuilder:rbac:groups=games.fredericbarrau.bzh,resources=pongs/finalizers,verbs=update

//+kubebuilder:rbac:groups=apps,resources=deployments,verbs=get;list;watch;create;update;patch;delete
//+kubebuilder:rbac:groups=core,resources=services,verbs=get;list;watch;create;update;patch;delete

// Reconcile is part of the main kubernetes reconciliation loop which aims to
// move the current state of the cluster closer to the desired state.
// TODO(user): Modify the Reconcile function to compare the state specified by
// the Pong object against the actual cluster state, and then
// perform operations to make the cluster state reflect the state specified by
// the user.
//
// For more details, check Reconcile and its Result here:
// - https://pkg.go.dev/sigs.k8s.io/controller-runtime@v0.16.3/pkg/reconcile
func (r *PongReconciler) Reconcile(ctx context.Context, req ctrl.Request) (ctrl.Result, error) {
	log := log.FromContext(ctx)

	log.Info("Reconciling Pong")

	// Fetch the pong instance
	var pong gamesv1alpha1.Pong
	if err := r.Get(ctx, req.NamespacedName, &pong); err != nil {
		log.Error(err, "unable to fetch Pong instance")
		// we'll ignore not-found errors, since they can't be fixed by an immediate
		// requeue (we'll need to wait for a new notification), and we can get them
		// on deleted requests.
		return ctrl.Result{}, client.IgnoreNotFound(err)
	}

	var replicas = int32(1)
	var deploymentName = pong.Name + "-deployment"
	var pong_image = default_pong_image

	if pong.Spec.ImageVersion != "" {
		pong_image = pong.Spec.ImageVersion
	}

	// Minimal Deployment spec, the rest will be handled by mutating webhooks (defaults, etc.)
	var deployment appsv1.Deployment = appsv1.Deployment{
		ObjectMeta: metav1.ObjectMeta{
			Name:      deploymentName,
			Namespace: req.Namespace,
			OwnerReferences: []metav1.OwnerReference{
				*metav1.NewControllerRef(&pong, gamesv1alpha1.GroupVersion.WithKind("Pong")),
			},
		},
		Spec: appsv1.DeploymentSpec{
			Replicas: &replicas,
			Selector: &metav1.LabelSelector{
				MatchLabels: map[string]string{
					"app": pong.Name,
				},
			},
			Template: corev1.PodTemplateSpec{
				ObjectMeta: metav1.ObjectMeta{
					Labels: map[string]string{
						"app": pong.Name,
					},
				},
				Spec: corev1.PodSpec{
					Containers: []corev1.Container{
						{
							Name:            "pong",
							Image:           pong_image,
							ImagePullPolicy: corev1.PullNever,
							Ports: []corev1.ContainerPort{
								{
									ContainerPort: 80,
									Name:          "http",
								},
							},
						},
					},
				},
			},
		},
	}
	if err := r.Get(ctx, client.ObjectKey{Namespace: req.Namespace, Name: deploymentName}, &deployment); err != nil {
		log.Info("Creating a new Deployment", "Deployment.Namespace", deployment.Namespace, "Deployment.Name", deployment.Name)
		if err := r.Create(ctx, &deployment); err != nil {
			log.Error(err, "Failed to create new Deployment", "Deployment.Namespace", deployment.Namespace, "Deployment.Name", deployment.Name)
			return ctrl.Result{}, err
		}
		// Deployment created successfully - don't requeue
	} else {
		log.Info("Deployment already exists", "Deployment.Namespace", deployment.Namespace, "Deployment.Name", deployment.Name)
		//TODO: check if the color of the CDR matches the param provided to the image in the deployment. If not, update the deployment and restart it

		// Check if the deployment is up to date regarding the image
		if deployment.Spec.Template.Spec.Containers[0].Image != pong_image {
			log.Info("Updating the Deployment", "Deployment.Namespace", deployment.Namespace, "Deployment.Name", deployment.Name)
			deployment.Spec.Template.Spec.Containers[0].Image = pong_image
			if err := r.Update(ctx, &deployment); err != nil {
				log.Error(err, "Failed to update Deployment", "Deployment.Namespace", deployment.Namespace, "Deployment.Name", deployment.Name)
				return ctrl.Result{}, err
			}
		}
	}

	// now we need to create a service for the deployment
	var service = corev1.Service{
		ObjectMeta: metav1.ObjectMeta{
			Name:      pong.Name + "-service",
			Namespace: req.Namespace,
			OwnerReferences: []metav1.OwnerReference{
				*metav1.NewControllerRef(&pong, gamesv1alpha1.GroupVersion.WithKind("Pong")),
			},
		},
		Spec: corev1.ServiceSpec{
			Selector: map[string]string{
				"app": pong.Name,
			},
			Type: corev1.ServiceTypeNodePort,
			Ports: []corev1.ServicePort{
				{
					Name:       "http",
					Port:       3000,
					TargetPort: intstr.FromInt(80),
				},
			},
		},
	}
	if err := r.Get(ctx, client.ObjectKey{Namespace: req.Namespace, Name: service.Name}, &service); err != nil {
		log.Info("Creating a new Service", "Service.Namespace", service.Namespace, "Service.Name", service.Name)
		if err := r.Create(ctx, &service); err != nil {
			log.Error(err, "Failed to create new Service", "Service.Namespace", service.Namespace, "Service.Name", service.Name)
			return ctrl.Result{}, err
		}
		// Service created successfully - don't requeue
	} else {
		log.Info("Service already exists", "Service.Namespace", service.Namespace, "Service.Name", service.Name)
	}
	return ctrl.Result{}, nil
}

// SetupWithManager sets up the controller with the Manager.
func (r *PongReconciler) SetupWithManager(mgr ctrl.Manager) error {

	return ctrl.NewControllerManagedBy(mgr).
		For(&gamesv1alpha1.Pong{}).
		Owns(&appsv1.Deployment{}). // Create watches for the Deployment which has its controller owned reference
		Owns(&corev1.Service{}).    // Create watches for the Deployment which has its controller owned reference
		Complete(r)
}
