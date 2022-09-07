# This page outlines how the system will interact with Ontrack 

## Summary of the design

We want to view what files have already been submitted by students along with a chat log similar to the conversation panel in a GitHub Pull Request.

 This Proof of Concept (POC) is sepperated into 2 modules that tightly interact with each other 

 * Front-end emulator (REST API)
 * Back-end git [library](https://github.com/ruby-git/ruby-git) interface 


 ## Front-end emulator


 Below are the methods used by the emulator

**HTTP GET /test**
Checks that there is connectivity to the server. If you recieve no response then you don't have connectivity

Response
```
{
    "Code" : "200",
    "Message": "Positive Outcome"
}

```

**HTTP GET /init**
Initialises a git repo and returns the uid of that repo

Response
```
{
    "respCode": 200|401|501
    "Message": string
}
```

**HTTP GET /:uid**
Retrieve an entire git repo for a given `uid`

Reponse
```
{
    "respCode": 200|300|400|500
    "repo": git
}
```

**HTTP GET /:uid/:filename
Retrieve a specific file in a git repo for a given `uid`

Response
```
{
    "respCode": 200|300|400|500
    "file": File object
}
```

**HTTP POST /:uid**


Body
```
{
    "file": "string",
    "fileName":"string",
    "commitMsg":string
}
```
Response
```
{
    "Code": 200|300|400|500
    "Message": string
}
```

**HTTP get /diff/:uid/:file
Retrieve the most recent commit that contains the searched for file

Response 
```
{
    "Code": 200|404,
    "Message": string
}

 ## Back-end Service

 The backend service will work tightly with the ruby library to perform the actions requested by the emulator.

 More to come.

 