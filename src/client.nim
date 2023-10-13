import os, threadpool, asyncdispatch, asyncnet
import protocol

proc connect(socket: AsyncSocket, serverAddr: string) {.async.} =
    echo("Initiating connection to: ", serverAddr)
    await socket.connect(serverAddr, 7687.Port)
    echo("You joined! 🚀🚀🚀")
    echo("________________________________________")

    while true:
        let line = await socket.recvLine()
        let parsed = parseMessage(line)
        echo(parsed.username, ": ", parsed.message)

echo("________________________________________")
echo("Chat Application [Built w/ Nim Language]")
echo("________________________________________")

if paramCount() != 2:
    quit("Please specify the server address e.g. ./client localhost username")

let serverAddr = paramStr(1)
let socket = newAsyncSocket()
asyncCheck connect(socket, serverAddr)

let username = paramStr(2)
var messageFlowVar = spawn stdin.readLine()
while true:
    if messageFlowVar.isReady():
        echo("You: ", ^messageFlowVar)
        let message = createMessage(username, ^messageFlowVar)
        asyncCheck socket.send(message)
        messageFlowVar = spawn stdin.readLine()    
        
    asyncdispatch.poll()

