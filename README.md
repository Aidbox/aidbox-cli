## Aidbox CLI

First: create account on https://aidbox.io

Now you need install aidbox-cli util globally

``` bash
$ sudo npm install -g aidbox-cli
```

After that, login to you aidbox.io account throw aidbox-cli util

``` bash
$ aidbox login
  Login: <enter oyu login>
  Password: <enter oyu password>
  OK: Auth success
```

Для начала работы вам необходимо создать три вещи\сущности\сделать три действия
Сооздать BOX - в котором будет находится ваше приложение, имплицитного слиента, от имени которого будет происходить деплой и атворизация, и пользователей бокса

Для создания нового бокса, выполните комманду:

``` bash
$ adibox box new <box-name>
  INFO: Create new box [boxname]
  OK: Box [boxname] created
  OK: Current box switch to [boxname]
``` 

После создания нового бокса, вы автоматически переключаетесь в контекст созданного бокса. Это означает, что все дальнейшие операции по созданию пользователе, слиентов, деплоя - будут выполняться в текущем боксе. 
Для просмотра текущего бокса, выполните:

``` bash
$ aidbox box
  OK: You current box [boxname]
``` 
Для просмотра списка всех доступных ранее созданных боксов, выполните:
``` bash
$ aidbox box list
  Тут типа красивый список доступных боксов с и ID и хостами
  Сейчас выводится просто JSON
```

Для переключения контекста между боксами, выполните:
``` bash
$ adibox box <other-box>
  OK: Current box switch to box [other-box]
```

Это может быть полезно, когда вы имеете, к примеру, два бокса test и prod. Вы ведете разработку в тестовом боксе. И когда вы хотите выложить своё приложение в prod, достаточно переключить контекст в prod, задеплоить приложение уже в прод бокс, вернуться обратно в тестовый и продолжить разработку.

Для деплоя вашего приложения, выполните:

``` bash
$ aidbox deploy
  INFO: Compress you app...
  INFO: Publish app...
  OK: you application was successfully uploaded in box [boxname]
```
Таким образом, воркфлоу при работе с двумя боксами __dev__ и __prod__ может иметь следующий вид:

``` bash
; Некоторые действия по разработке приложения
; Написание кода, сборка приложения, тестирование
; Теперь нам необходимо задеплоить приложение в dev бокс
; и убедиться, что все работает

$ aidbox box 
  OK: You current box [dev]
$ adibox deploy
  INFO: Compress you app...
  INFO: Publish app...
  OK: you application was successfully uploaded in box [dev]

; Если все работает как и задумывалось, то можно задеплоить приложение в prod бокс

$ aidbox box prod
  OK: You current box [prod]
$ adibox deploy
  INFO: Compress you app...
  INFO: Publish app...
  OK: you application was successfully uploaded in box [prod]

; Возвращаемся обратно в dev бокс

$ aidbox box dev
  OK: You current box [dev]
```
Clone sample app:

$ git clone https://github.com/Aidbox/sample.git

Install all packages:

$ npm install && bower install
