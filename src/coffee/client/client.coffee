#
# Copyright (C) 2015 by Looker Data Services, Inc.
# All rights reserved.
#

# Allow Node.js-style `global` in addition to `window`
if typeof(global) is 'undefined'
    window.global = window

# Load JSData libraries. The core library must be first.
require 'js-data'
window.DSLocalStorageAdapter = require 'js-data-localstorage'
require 'js-data-angular'

# Include the Reflux module
require './modules/reflux'

# Add 'require' statements for your other Angular module files here.
require './modules/client_schema'
require './modules/todo/todo_item_module'
require './modules/todo/todo_list_module'
require './modules/todo/input_module'
require './../read_only_view'

angular = require 'angular'

# Add all your modules here.
MODULES = [
    'reflux'
    'schema'
    'todo'
]

############################################################################################################

angular.module 'app', MODULES
    .config ($locationProvider)->
        $locationProvider.html5Mode true

console.log "client is ready"
