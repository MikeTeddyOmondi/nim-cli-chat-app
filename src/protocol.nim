import json

type
    Message* = object
        username*: string
        message*: string

proc parseMessage*(data: string): Message =
    let jsonData = parseJson(data)
    result.username = jsonData["username"].getStr()
    result.message = jsonData["message"].getStr()

proc createMessage*(username, message: string): string =
    result = $(%{
        "username": %username,
        "message": %message
    }) & "\c\l"


# Tests    
when isMainModule:    
    block:
        let data = """{"username": "John", "message": "Hi!"}"""
        let parsed = parseMessage(data)
        doAssert parsed.username == "John"
        doAssert parsed.message == "Hi!!"

    block:
        let data = """foobar"""
        # let data = """{"username": "John", "message": "Hi!"}"""
        try:
            let parsed = parseMessage(data)
            echo(parsed.message)
            doAssert false
        except JsonParsingError:
            doAssert true
        except:
            doAssert false

    block:
        let expected = """{"username":"dom","message":"hello"}""" & "\c\l"
        doAssert createMessage("dom", "hello") == expected

