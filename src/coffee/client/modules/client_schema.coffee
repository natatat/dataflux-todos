#
# Copyright (C) 2015 by Looker Data Services, Inc.
# All rights reserved.
#

angular = require 'angular'

############################################################################################################

schema = angular.module 'schema', ['js-data']

schema.factory 'Todo', (DS) -> DS.defineResource require '../../model/todo_model'

# force the services to be created so that recursive lookups succeed
schema.run (Todo) -> # do nothing
