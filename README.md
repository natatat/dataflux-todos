### How to use things...

|                      |               |
|----------------------|---------------|
| Building the project | `grunt build` |
| Running the server   | `grunt start` |
| Watching changes     | `grunt watch` |
| Cleaning the project | `grunt clean` |

Once the server is running, you should be able to connect to `http://localhost:8080`

## Some notes:

### Stores
- NEVER fire Actions
- listen to Actions & execute on[Action] handlers, then trigger notifications that their state has changed
- A Controller listens for these notifications and updates its $scope accordingly (which triggers a $watch and upates the DOM)
- ex: [TextInput flow](https://github.com/natatat/dataflux-todos/blob/reflux/src/coffee/client/modules/todo/input_module.coffee)
- ex: [TodoItem flow](https://github.com/natatat/dataflux-todos/blob/reflux/src/coffee/client/modules/todo/todo_item_module.coffee)
- ex: [TodoList flow](https://github.com/natatat/dataflux-todos/blob/reflux/src/coffee/client/modules/todo/todo_list_module.coffee)

### Controllers
- listen to notifications emitted from Stores when state changes, updates it's $scope accordingly
- fires Actions based on user DOM interaction
