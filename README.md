
# Aidbox CLI

[![Build Status](https://travis-ci.org/Aidbox/aidbox-cli.svg?branch=0.4.2)](https://travis-ci.org/Aidbox/aidbox-cli)


First, create an account on https://aidbox.io.

Now you need to install aidbox-cli utility globally. Also you may need to install coffee-script.

``` bash
$ sudo npm install -g aidbox-cli
$ aidbox v
  OK: v0.5.10
```

## Logging In and Out

Let's log in your aidbox.io account throught the aidbox-cli utility:

``` bash
$ aidbox login
  Login: <enter your login>
  Password: <enter your password>
  OK: Auth success
```

Then try to log out:

``` bash
$ aidbox logout
  OK: Now you are logged out
  OK: All session data has been removed
```

Also you can log in via inline style

``` bash
$ aidbox login <email> <password>
  OK: Auth success
```

# Getting Started

In order to start working with Aidbox, you have to do 3 things:

1. Create a box, which will host your application.
2. Create an implicit client, on behalf of which deploy and authorization will be performed.
3. Create users of the box.

## Box

__box__ is a command for managing boxes. By means of this command it's possible to create new boxes, view a list of all existing boxes, switch between boxes, delete boxes and so on.

To view a list of all possible subcommands, execute:

``` bash
$ aidbox box help
  box                 -- Display current box
  box new <boxname>   -- Create new box with specified  <boxname>
  box list            -- Display all available boxes
  box use <boxname>   -- Switch current box to <boxname>
  box destroy         -- Destroy current box [!not ready yet!]
```

###  Box Commands

#### box

Outputs your current box:

``` bash
$ aidbox box
  OK: Your current box is [boxname]
```

#### box new

Creates a new box. After creation of a new box, you will be automatically switched to the newly created box context. It means that all futher operations, such as creating users, clients, deploy, etc will be done in this box.

``` bash
$ aidbox box new <boxname>
  INFO: Create new box [boxname]
  OK: Box [boxname] has been created
  OK: Current box has been switched to [boxname]
```

#### box list

Outputs a list of all available boxes.

``` bash
$ aidbox box list
  Outputs a list of all available boxes with their IDs and hosts. For now it's a raw JSON.
```

#### box use

Switches a context of command execution to a specified box.

``` bash
$ aidbox box use <other-box>
  OK: Current box has been switched to box [other-box]
```

#### box destroy - not ready yet

Deletes current box.

``` bash
$ aidbox destroy
  ; Not ready yet
```

### User Commands

__user__ is a command for working with users in current box. To view a list of all available subcommands, execute:

``` bash
$ aidbox user help
  user list                -- Display a list of users in current box
  user help                -- Show help information
  user new                 -- Create a user via wizard
  user new email:password  -- Create a user inline
```

#### user list

Outputs a list of all users in current box.

``` bash
$ aidbox user list
  INFO: Display a list of users in box [boxname]
  ; For now it displays raw JSON
```

#### user new

Creates a new user using a wizard, in current box.

``` bash
$ aidbox user new
  INFO: Create new user in box [boxname]
  Email: <test@gmail.com>
  Password: <password>
  OK: User [test@gmail.com] has been successfully created in box [boxname]
```

Another command to create a user inline without a wizard, has the following syntax:

aidbox user new email:password

``` bash
$ aidbox user new test_2@gmail.com:password
  INFO: Create new user in box [boxname]
  OK: User [test_2@gmail.com] has been successfully created in box [boxname]
```

### deploy

__deploy__ command deploys your application to a box. By default it deploys content of the ``` dist ``` folder in the root of your application. You can specify the folder to be depoyed in a box, as well. For example, it can be ```public```, ```build```, etc.

``` bash
$ aidbox deploy build
  INFO: Compress you app...
  INFO: Publish app...
  OK: You application has been successfully uploaded in box [boxname]
  OK: Temp files have been removed
```

### Example Workflow

Here is a typical development workflow. Let us suppose there are two boxes  __dev-myapp__ and __prod-myapp__. Currently you are working in  __dev-myapp__ box. When you want to deploy your application on __prod-myapp__,  all you need is to swich context to __prod-myapp__, execute deploy operation in __prod-myapp__, come back to __dev-myapp__ and continue development.

Thus,  a workflow for two boxes __dev-myapp__ and __prod-myapp__ may look like:

``` bash
$ aidbox login
$ aidbox box new dev-myapp
$ aidbox box new prod-myapp
$ aidbox box use dev-myapp

; Some actions for the development of an application
; Writing code, building application, testing
; Now you need to deploy your application to dev-myapp box
; and nake sure eerything is working

$ aidbox box
$ adibox deploy

; If everything works as intended, you can deploy application to prod-myapp box

$ aidbox box use prod-myapp
$ adibox deploy

; Return back into dev-myapp box

$ aidbox box use dev-myapp

; And continue development
```
