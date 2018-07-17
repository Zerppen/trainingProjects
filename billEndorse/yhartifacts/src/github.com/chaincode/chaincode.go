package main

import (
	"fmt"

	"github.com/hyperledger/fabric/core/chaincode/shim"
	pb "github.com/hyperledger/fabric/protos/peer"
)

type TracingChaincode struct {
}

// Init ...
func (t *TracingChaincode) Init(stub shim.ChaincodeStubInterface) pb.Response {
	return shim.Success(nil)
}

// Invoke ...
func (t *TracingChaincode) Invoke(stub shim.ChaincodeStubInterface) pb.Response {
	function, args := stub.GetFunctionAndParameters()
	fmt.Printf("Invoke func: %s args: %v\n", function, args)
	if function == "putValue" {
		if len(args) < 2 {
			return shim.Error("The length of args less than 2.")
		}

		stub.PutState(args[0], []byte(args[1]))
		return shim.Success([]byte(args[0]))
	} else if function == "getValue" {
		if len(args) < 1 {
			return shim.Error("The length of args less than 1.")
		}

		data, err := stub.GetState(args[0])
		if err != nil {
			return shim.Error(err.Error())
		}
		return shim.Success(data)
	}

	return shim.Error(fmt.Sprintf("Unsupported function: %s", function))
}

func main() {
	err := shim.Start(new(TracingChaincode))
	if err != nil {
		fmt.Printf("Error starting tracing chaincode: %s", err)
	}
}
