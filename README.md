## Aidbox CLI

First create account on http://aidbox.io


Now you need install aidbox-cli util globally
Возможно, вам также понадобится Coffee-script

``` bash
$ sudo npm install -g coffee-script
$ sudo npm install -g aidbox-cli
$ aidbox v
  OK: v0.4.1
```

### Login and Logout
After that, login to you aidbox.io account throw aidbox-cli util

``` bash
$ aidbox login
  Login: <enter oyu login>
  Password: <enter oyu password>
  OK: Auth success
```

Для выхода из акааунта, выполните
``` bash
$ aidbox logout
  OK: You are now logged out
  OK: All session data are removed
```

###Begin
Для начала работы вам необходимо создать три вещи\сущности\сделать три действия

* Сооздать BOX - в котором будет находится ваше приложение
* Bмплицитного слиента, от имени которого будет происходить деплой и атворизация
* Пользователей бокса

### box
__box__  - комманда для управления боксами. С её помощью можно создавать новые боксы, просмотреть список всех доступных боксов, переключаться между боксами, _удалить бокс_ и т.д.

Для просмотра списка всех доступных подкоманд выполните:
``` bash
$ aidbox box help
  box                 -- Display current box
  box new <boxname>   -- Create new box with name <boxname>
  box list            -- Show all available boxes
  box use <boxname>   -- Switch current box to <boxname>
  box destroy         -- Destroy current box [!not ready!]
```

#### box
Просмотр текущего бокса

``` bash
$ aidbox box
  OK: You current box [boxname]
``` 
#### box new
Создание нового бокса. 
После создания нового бокса, вы автоматически переключаетесь в контекст созданного бокса. Это означает, что все дальнейшие операции по созданию пользователей, слиентов, деплоя т.д. - будут выполняться в новом боксе. 
``` bash
$ adibox box new <box-name>
  INFO: Create new box [boxname]
  OK: Box [boxname] created
  OK: Current box switch to [boxname]
``` 
#### box list
Просмотр списка всех доступных боксов
``` bash
$ aidbox box list
  Тут типа красивый список доступных боксов с и ID и хостами
  Сейчас выводится просто JSON
```
#### box use
Переключает контекст выполнения в заданный бокс. 
``` bash
$ adibox box use <other-box>
  OK: Current box switch to box [other-box]
```
#### box destroy - пока не готово
Удаление текущего бокса 
``` bash
$ adibox destroy
  ; Не готово
```
### user 
__user__ - команда для работы с пользователями в текущем боксе
Для просмотра списка всех доступных подкоманд выполните:
``` bash
$ aidbox user help
  user list                -- Show users list in current box
  user help                -- Show help
  user new                 -- Create user via wizard
  user new email:password  -- Create user one line
```
#### user list
Отображает список всех пользователей в текущем боксе
``` bash
$ aidbox user list
  INFO: Users list in box [boxname]
  ; Типа красивый список
  ; Пока просто JSON
```
#### user new
Создание пользователя в текущем боксе с помощью визарда
``` bash
$ aidbox user new
  INFO: Create new user in box [boxname]
  Email: <test@gmail.com>
  Password: <password>
  OK: User [test@gmail.com] created successfully in box [boxname]
```
Также доступно создание пользователя в одну строку, указав вторым параметров Email и пароль через двоеточие
``` bash
$ aidbox user new test_2@gmail.com:password
  INFO: Create new user in box [boxname]
  OK: User [test_2@gmail.com] created successfully in box [boxname]
```

### deploy
__deploy__ - деплой вашего приложения в бокс.
По умолчанию, в бокс деплоится содержимое паки ``` dist ``` в корне вашего приложения.
Также, вы можете указать, какую именно папку необходимо задеплоить в бокс. К примеру, это могут быть ```public```, ```build``` и т.д.


``` bash
$ aidbox deploy build
  INFO: Compress you app...
  INFO: Publish app...
  OK: you application was successfully uploaded in box [boxname]
  OK: Tmp files removed
```


### Workflow example
Типичный воркфлоу разработки может выглядеть следующим образом.
Допустим, у вас есть два бокса __dev-myapp__ и __prod-myapp__. Вы ведете разработку в __dev-myapp__ боксе. И когда вы хотите выложить своё приложение в __prod-myapp__, достаточно переключить контекст в __prod-myapp__, задеплоить приложение уже в __prod-myapp__ бокс, вернуться обратно в __dev-myapp__ и продолжить разработку.

Таким образом, воркфлоу при работе с двумя боксами __dev__ и __prod__ может иметь следующий вид:

``` bash
$ aidbox login
$ aidbox box new dev-myapp
$ aidbox box new prod-myapp
$ aidbox box use dev

; Некоторые действия по разработке приложения
; Написание кода, сборка приложения, тестирование
; Теперь нам необходимо задеплоить приложение в dev бокс
; и убедиться, что все работает

$ aidbox box 
$ adibox deploy 

; Если все работает как и задумывалось, то можно задеплоить приложение в prod бокс

$ aidbox box use prod
$ adibox deploy

; Возвращаемся обратно в dev бокс

$ aidbox box use dev

; Продолжаем разработку
```


