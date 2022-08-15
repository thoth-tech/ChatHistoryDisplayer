# Chat History Displayer

## Shows the chat history and version controlled file submission.
### Supported by the Task View and Submission redesign team

We will be utilising a ruby [library](https://github.com/ruby-git/ruby-git) to interface with git to display what files are new and what are already submitted for any given submission. 

We will create a working Proof of Concept (POC) in this repo before working on intergrating with the doubfire backend. 

## [DESIGN.md](./DESIGN.md)

A simple overview of the proposed solution

![image](./overview.png)

# Getting the emulator running

The emulator is a simple HTTP server running on [Sinatra](https://sinatrarb.com/), a Ruby server library. 

**Requirements**

Make sure you have ruby installed on your machine. Then you'll want to install the following tools to run the emulator.

```
sudo gem install sinatra
sudo gem install rerun
sudo gem install <missing_package_name_here>
```

To run the server, simply enter `rerun 'ruby main.rb'` into the terminal in the same directory as the emulator. 

Navigate to `localhost:4567` on a web brower to see the server running.

You'll want to install a tool like [Postman](https://www.postman.com/) to invoke all of the methods in the emulator or use command line tools like [curl](https://curl.se/)