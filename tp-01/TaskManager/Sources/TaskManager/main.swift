import TaskManagerLib

let taskManager = createTaskManager()

let taskPool = taskManager.places.first{$0.name == "taskPool"}!
let processPool = taskManager.places.first{$0.name == "processPool"}!
let inProgress = taskManager.places.first{$0.name == "inProgress"}!

let create = taskManager.transitions.first{$0.name == "create"}!
let success = taskManager.transitions.first{$0.name == "success"}!
let spawn = taskManager.transitions.first{$0.name == "spawn"}!
let exec = taskManager.transitions.first{$0.name == "exec"}!
let fail = taskManager.transitions.first{$0.name == "fail"}!


let m1 = create.fire(from: [taskPool: 0, processPool: 0, inProgress: 0]) // After the initialisation [taskPool: 1, processPool: 0, inProgress: 0]
let m2 = spawn.fire(from: m1!)											 // [taskPool: 1, processPool: 1, inProgress: 0]
let m3 = spawn.fire(from: m2!)											 // [taskPool: 1, processPool: 2, inProgress: 0]
let m4 = exec.fire(from: m3!)											 // [taskPool: 1, processPool: 1, inProgress: 1]
let m5 = exec.fire(from: m4!)											 // [taskPool: 1, processPool: 0, inProgress: 2]
let m6 = success.fire(from: m5!)										 // [taskPool: 0, processPool: 0, inProgress: 1]
let m7 = fail.fire(from: m6!)											 /* [taskPool: 0, processPool: 0, inProgress: 0] here it has to fail because the task is trying to pocessing is already succeded, 
																		     the problem with this model is that we can execute the same task without knowing if it succeded or failed
																		 */
let correctTaskManager = createCorrectTaskManager()

let taskPoolN = correctTaskManager.places.first{$0.name == "taskPool"}!
let processPoolN = correctTaskManager.places.first{$0.name == "processPool"}!
let inProgressN = correctTaskManager.places.first{$0.name == "inProgress"}!
let freeSpace = correctTaskManager.places.first{$0.name == "freeSpace"}!

let createN = correctTaskManager.transitions.first{$0.name == "create"}!
let successN = correctTaskManager.transitions.first{$0.name == "success"}!
let spawnN = correctTaskManager.transitions.first{$0.name == "spawn"}!
let execN = correctTaskManager.transitions.first{$0.name == "exec"}!
let failN = correctTaskManager.transitions.first{$0.name == "fail"}!

let m1N = createN.fire(from: [taskPool: 0, processPool: 0, inProgress: 0, freeSpace: 1]) 	// After the initialisation [taskPoolN: 1, processPoolN: 0, inProgressN: 0, freeSpaceN: 1]
let m2N = spawnN.fire(from: m1N!)											 				// [taskPoolN: 1, processPoolN: 1, inProgressN: 0, freeSpaceN: 1]
let m3N = spawnN.fire(from: m2N!)											 				// [taskPoolN: 1, processPoolN: 2, inProgressN: 0, freeSpaceN: 1]
let m4N = execN.fire(from: m3N!)											 				// [taskPoolN: 1, processPoolN: 1, inProgressN: 1, freeSpaceN: 0]
//let m5N = execN.fire(from: m4N!)											 				// this line doesn't work because there is no freeSpace for executing another task 
let m5N = successN.fire(from: m4N!)										 					// [taskPoolN: 0, processPoolN: 1, inProgressN: 0, freeSpaceN: 1]
// in this case we can't follow the same execution like in taskManager, so to clean the processPoolN we have to execute another createN
let m6N = createN.fire(from: m5N!)															// [taskPoolN: 1, processPoolN: 1, inProgressN: 0, freeSpaceN: 1]
let m7N = execN.fire(from: m6N!)															// [taskPoolN: 1, processPoolN: 0, inProgressN: 1, freeSpaceN: 0]
// here we can choose to execute both successN or failN and we will have a correct output of the model
//let m8N = successN.fire(from: m7N!)														// [taskPoolN: 0, processPoolN: 0, inProgressN: 0, freeSpaceN: 1]
//let m8N = failN.fire(from: m7N!)															// [taskPoolN: 1, processPoolN: 0, inProgressN: 0, freeSpaceN: 1]