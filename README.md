# OpenProject Work Package Required Fields

`openproject-work-package-required-fields` is a standalone plugin scaffold for OpenProject.

The repository currently contains:

- plugin gem structure
- OpenProject engine registration
- I18n locale seed
- placeholder extension points for future required field logic

## Development

1. Clone this repository next to your OpenProject checkout.
2. Add the plugin to the OpenProject `Gemfile.plugins`.
3. Run bundle install in the OpenProject application.
4. Restart the OpenProject server.

Example `Gemfile.plugins` entry:

```ruby
gem "openproject-work-package-required-fields", path: "../openproject-work-package-required-fields"
```

## Подключение плагина

1. Склонируйте этот репозиторий рядом с вашей установкой OpenProject.
2. Добавьте плагин в файл `Gemfile.plugins` внутри OpenProject.
3. Выполните `bundle install` в приложении OpenProject.
4. Перезапустите OpenProject.

Пример записи для `Gemfile.plugins`:

```ruby
gem "openproject-work-package-required-fields", path: "../openproject-work-package-required-fields"
```

## Версия Ruby

Для OpenProject 17 используйте ту же версию Ruby, что и в целевой установке OpenProject.
На текущий момент рекомендуемая версия: `Ruby 3.4.7`.

## Next Steps

- define which work package fields become required for each rule
- implement policy or query patches under `lib/open_project/work_package_required_fields`
- add tests once behavior is finalized
