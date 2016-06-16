/*
Copyright (c) 2015 The Polymer Project Authors. All rights reserved.
This code may only be used under the BSD style license found at http://polymer.github.io/LICENSE.txt
The complete set of authors may be found at http://polymer.github.io/AUTHORS.txt
The complete set of contributors may be found at http://polymer.github.io/CONTRIBUTORS.txt
Code distributed by Google as part of the polymer project is also
subject to an additional IP rights grant found at http://polymer.github.io/PATENTS.txt
*/

(function(document) {
    'use strict';

    // See https://github.com/Polymer/polymer/issues/1381
    window.addEventListener('WebComponentsReady', function() {
        // imports are loaded and elements have been registered
    });

    // Main area's paper-scroll-header-panel custom condensing transformation of
    // the appName in the middle-container and the bottom title in the bottom-container.
    // The appName is moved to top and shrunk on condensing. The bottom sub title
    // is shrunk to nothing on condensing.
    window.addEventListener('paper-header-transform', function(e) {
        var appName = Polymer.dom(document).querySelector('#mainToolbar .app-name');
        var middleContainer = Polymer.dom(document).querySelector('#mainToolbar .middle-container');
        var bottomContainer = Polymer.dom(document).querySelector('#mainToolbar .bottom-container');
        var detail = e.detail;
        var heightDiff = detail.height - detail.condensedHeight;
        var yRatio = Math.min(1, detail.y / heightDiff);
        // appName max size when condensed. The smaller the number the smaller the condensed size.
        var maxMiddleScale = 0.50;
        var auxHeight = heightDiff - detail.y;
        var auxScale = heightDiff / (1 - maxMiddleScale);
        var scaleMiddle = Math.max(maxMiddleScale, auxHeight / auxScale + maxMiddleScale);
        var scaleBottom = 1 - yRatio;

        // Move/translate middleContainer
        Polymer.Base.transform('translate3d(0,' + yRatio * 100 + '%,0)', middleContainer);

        // Scale bottomContainer and bottom sub title to nothing and back
        Polymer.Base.transform('scale(' + scaleBottom + ') translateZ(0)', bottomContainer);

        // Scale middleContainer appName
        Polymer.Base.transform('scale(' + scaleMiddle + ') translateZ(0)', appName);
    });

    // paper-datatable

    var table = document.querySelector('.mtrl-table');

    table.data = {
        queryForIds: function(sort, page, pageSize){
            db.count(app.searchTerm, sort, (page-1)*pageSize, page*pageSize).then(function(count){
                app.set('data.length', count);
            });
            return db.select('id', app.searchTerm, sort, (page-1)*pageSize, page*pageSize);
        },
        getByIds: function(ids){
            return db.select('*', ids);
        },
        set: function(item, property, value){
            return db.update(item.id, property, value);
        },
        length:0
    };

    table.clip = function(value){
        var substr = value.substr(0, 40);
        if(substr.length < 40){
            return substr;
        }else{
            return substr + '...';
        }
    };

    table.formatLatLng = function(value){
        var lat = (value.lat > 0 ? '&nbsp;': '') + (value.lat < 10 && value.lat > -10 ? '&nbsp;': '') + value.lat.toFixed(6);
        var lng = (value.lng > 0 ? '&nbsp;': '') + (value.lng < 10 && value.lng > -10 ? '&nbsp;': '') + (value.lng < 100 && value.lng > -100 ? '&nbsp;': '') + value.lng.toFixed(6);
        return lat + ' | ' + lng;
    };

    table.deleteSelected = function(){
        app.selectedIds.forEach((id) => {
            var index = users.findIndex((item) => id == item.id);
            users.splice(index, 1);
        });
        this.$.datatableCard.retrieveVisibleData();
        this.$.datatableCard.deselectAll();
        saveToLocalStorage();
    };

    table.editDialogForSelected = function(){
        this.$.editDialog.opened = true;
    };

    table.onlyFirst = function(item, index){
        if(typeof index === 'undefined'){
            alert('Please see issue #34');
        }
        if(index == 0){
            return true;
        }
    };

    table.rowTapped = function(ev){
        if(app.isDebouncerActive('dblclick'+ev.detail.item.id)){
            //double click
            app.$.datatableCard.deselectAll();
            app.$.datatableCard.select(ev.detail.item.id);
            app.editDialogForSelected();
            ev.preventDefault();
            app.cancelDebouncer('dblclick');
        }else{
            app.debounce('dblclick'+ev.detail.item.id, function(){}, 300);
        }
    };

    table.retrieveResults = function(ev){
        app.$.datatableCard.retrieveVisibleData();
    };

})(document);
