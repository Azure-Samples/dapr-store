// ----------------------------------------------------------------------------
// Copyright (c) Ben Coleman, 2020
// Licensed under the MIT License.
//
// Mock implementation of the UserService for testing
// ----------------------------------------------------------------------------

package mock

import (
	"encoding/json"
	"os"

	"github.com/azure-samples/dapr-store/cmd/users/impl"
	"github.com/azure-samples/dapr-store/cmd/users/spec"
)

// UserService mock
type UserService struct {
}

// Load mock data
var mockUsers []spec.User

func init() {
	mockJSON, err := os.ReadFile("../../data/mock/users.json")
	if err != nil {
		panic(err)
	}

	err = json.Unmarshal(mockJSON, &mockUsers)
	if err != nil {
		panic(err)
	}
}

// GetUser mock
func (s UserService) GetUser(userID string) (*spec.User, error) {
	for _, user := range mockUsers {
		if user.UserID == userID {
			return &user, nil
		}
	}

	return nil, impl.UserNotFoundError()
}

// AddUser mock
func (s UserService) AddUser(user spec.User) error {
	userCheck, _ := s.GetUser(user.UserID)
	if userCheck != nil {
		return impl.UserDuplicateError()
	}

	mockUsers = append(mockUsers, user)

	return nil
}
