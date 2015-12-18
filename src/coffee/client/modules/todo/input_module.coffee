#
# Copyright (C) 2015 by Looker Data Services, Inc.
# All rights reserved.
#

angular   = require 'angular'
templates = require '../../templates'
{EVENT}   = require '../../../constants'
_         = require '../../../underscore'

############################################################################################################

todo = angular.module('todo')

todo.factory 'TextInputActions', (reflux) ->
    reflux.createActions ['setValue', 'clearValue']

todo.factory 'TextInputStore', (TextInputActions, reflux) ->
    reflux.createStore

        listenables: TextInputActions

        init: ->
            @_value = ""

        onSetValue: (value) ->
            @_value = value
            @trigger(EVENT.CHANGE)

        onClearValue: ->
            @_value = ""
            @trigger(EVENT.CHANGE)

todo.directive 'textInput', () ->
    restrict: 'E'
    scope: {}
    template: templates['text-input']
    controllerAs: 'controller'
    controller: ($scope, TextInputActions, TextInputStore) ->
        TextInputStore.$listen($scope, (event, id) ->
            $scope.value = TextInputStore._value
        )

        $scope.setValue = (value) ->
            TextInputActions.setValue(value)
