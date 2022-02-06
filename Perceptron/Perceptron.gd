class_name Perceptron extends Node

var weights: PoolRealArray = []
var inputs: PoolRealArray = []
const LearningRate = 0.1

func _init(inputs):
	self.inputs = inputs
	for i in len(inputs):
		weights.append(rand_range(-1.0, 1.0))

func guess():
	var sum = 0
	for i in weights.size():
		sum += inputs[i]*weights[i]
	return step(sum)

func step(n):
	if n >=0:
		return 1
	else:
		return -1

func train(target):
	var guess = guess()
	var error = target - guess
	for i in weights.size():
		weights[i] += error * inputs[i] * LearningRate
