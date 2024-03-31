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

package v1alpha1

import (
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
)

// EDIT THIS FILE!  THIS IS SCAFFOLDING FOR YOU TO OWN!
// NOTE: json tags are required.  Any new fields you add must have json tags for the fields to be serialized.

// PongSpec defines the desired state of Pong
type PongSpec struct {
	// INSERT ADDITIONAL SPEC FIELDS - desired state of cluster
	// Important: Run "make" to regenerate code after modifying this file

	// BallColor controls the color of the ball
	BallColor string `json:"ballColor,omitempty"`
	// Version of the pong application to deploy
	// Use the image type of the controller runtime
	// to specify the image version
	// +kubebuilder:validation:Pattern=`^pong:[0-9]+\.[0-9]+\.[0-9]+$`
	ImageVersion string `json:"imageVersion,omitempty"`
}

// PongStatus defines the observed state of Pong
type PongStatus struct {
	// INSERT ADDITIONAL STATUS FIELD - define observed state of cluster
	// Important: Run "make" to regenerate code after modifying this file
}

//+kubebuilder:object:root=true
//+kubebuilder:subresource:status

// Pong is the Schema for the pongs API
type Pong struct {
	metav1.TypeMeta   `json:",inline"`
	metav1.ObjectMeta `json:"metadata,omitempty"`

	Spec   PongSpec   `json:"spec,omitempty"`
	Status PongStatus `json:"status,omitempty"`
}

//+kubebuilder:object:root=true

// PongList contains a list of Pong
type PongList struct {
	metav1.TypeMeta `json:",inline"`
	metav1.ListMeta `json:"metadata,omitempty"`
	Items           []Pong `json:"items"`
}

func init() {
	SchemeBuilder.Register(&Pong{}, &PongList{})
}
