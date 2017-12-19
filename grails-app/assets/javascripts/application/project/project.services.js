/*
 * Copyright (c) 2014 Kagilum SAS.
 *
 * This file is part of iceScrum.
 *
 * iceScrum is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published by
 * the Free Software Foundation, either version 3 of the License.
 *
 * iceScrum is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with iceScrum.  If not, see <http://www.gnu.org/licenses/>.
 *
 * Authors:
 *
 * Vincent Barrier (vbarrier@kagilum.com)
 *
 */
services.factory('Project', ['Resource', function($resource) {
    return $resource('/project/:id/:action',
        {id: '@id'},
        {
            listByUserAndRole: {
                url: '/project/user/:userId/:role',
                isArray: true,
                method: 'get'
            },
            listByPortfolio: {
                url: '/project/portfolio/:portfolioId',
                isArray: true,
                method: 'get'
            }
        });
}]);

services.service("ProjectService", ['Project', 'Session', 'FormService', 'CacheService', 'IceScrumEventType', function(Project, Session, FormService, CacheService, IceScrumEventType) {
    var crudMethods = {};
    crudMethods[IceScrumEventType.CREATE] = function(project) {
        CacheService.addOrUpdate('project', project);
    };
    crudMethods[IceScrumEventType.UPDATE] = function(project) {
        CacheService.addOrUpdate('project', project);
    };
    crudMethods[IceScrumEventType.DELETE] = function(project) {
        CacheService.remove('project', project.id);
    };
    this.get = function(id) {
        return Project.get({id: id}).$promise;
    };
    this.save = function(project) {
        project.class = 'project';
        return Project.save(project).$promise;
    };
    this.updateTeam = function(project) {
        // Wrap the project inside a "projectd" because by default the formObjectData function will turn it into a "project" object
        // The "project" object conflicts with the "project" attribute expected by a filter which expects it to be either a number (id) or string (pkey)
        return Project.update({id: project.id, action: 'updateTeam'}, {projectd: project}).$promise;
    };
    this.update = function(project) {
        return Project.update({id: project.id}, {projectd: project}).$promise;
    };
    this.leaveTeam = function(project) {
        return Project.update({id: project.id, action: 'leaveTeam'}, {}).$promise;
    };
    this.archive = function(project) {
        return Project.update({id: project.id, action: 'archive'}, {}).$promise;
    };
    this.unArchive = function(project) {
        return Project.update({id: project.id, action: 'unArchive'}, {}).$promise;
    };
    this['delete'] = function(project) {
        return Project.delete({id: project.id}).$promise;
    };
    this.list = function(params) {
        if (!params) {
            params = {};
        }
        params.paginate = true;
        return Project.get(params).$promise;
    };
    this.listPublic = function(params) {
        if (!params) {
            params = {};
        }
        params.action = 'listPublic';
        params.paginate = true;
        return Project.get(params).$promise;
    };
    this.listPublicWidget = function() {
        return Project.query({action: 'listPublicWidget'}).$promise;
    };
    this.listByUser = function(params) {
        if (!params) {
            params = {};
        }
        params.action = 'user';
        params.paginate = true;
        return Project.get(params).$promise;
    };
    this.listByUserAndRole = function(userId, role, params) {
        if (!params) {
            params = {};
        }
        params.userId = userId;
        params.role = role;
        return Project.listByUserAndRole(params).$promise;
    };
    this.listByPortfolio = function(portfolioId) {
        return Project.listByPortfolio({portfolioId: portfolioId}).$promise
    };
    this.getActivities = function(project) {
        return Project.query({action: 'activities', id: project.id}).$promise; // TODO use httpGet
    };
    this.openChart = function(project, chart) {
        return Project.get({id: project.id, action: chart}).$promise; // TODO use httpGet
    };
    this.authorizedProject = function(action, project) {
        switch (action) {
            case 'unArchive':
                return Session.admin();
            case 'upload':
                return Session.poOrSm();
            case 'update':
            case 'updateProjectMembers':
                return Session.sm();
            case 'delete':
                return Session.owner(project);
            case 'edit':
                return Session.authenticated();
            default:
                return false;
        }
    };
    this.getVersions = function() {
        return FormService.httpGet('project/versions');
    };
    this.getTags = function() {
        return FormService.httpGet('search/tag');
    };
    this.countMembers = function(project) { // Requires the team to be loaded !
        return _.union(_.map(project.team.scrumMasters, 'id'), _.map(project.team.members, 'id'), _.map(project.productOwners, 'id')).length;
    };
}]);
