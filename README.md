## Запуск:

1.

```bash 
$ git clone git@gitlab.edu.rnds.pro:efalin/telegram-ruby-bot-rnds.git
$ cd telegram-ruby-bot-rnds
$ git checkout dev 
```


2. Ввести токен бота в файл constants.rb

```ruby
TOKEN = 'YOUR_TELEGRAM_BOT_API_TOKEN'
```


3. Открыть паралелльно два терминала


4. Запустить в первом файл sender.rb

```bash
$ ruby sender.rb
```


5. Запустить во втором файл bot.rb

```bash
$ ruby bot.rb
```