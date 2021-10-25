sap.ui.define([
	"sap/ui/core/mvc/Controller",
	"sap/ui/core/routing/History"
], function (Controller, History) {
	"use strict";

	return Controller.extend("be.dimensys.assetperformance.assetperformance.controller.BaseController", {

		getRouter: function () {
			return sap.ui.core.UIComponent.getRouterFor(this);
		},

		getModel: function (sName) {
			return this.getView().getModel(sName);
		},

		setModel: function (oModel, sName) {
			return this.getView().setModel(oModel, sName);
		},

		getResourceBundle: function () {
			return this.getOwnerComponent().getModel("i18n").getResourceBundle();
		},

		getLocalEventBus: function () {
			return this.getOwnerComponent().getEventBus();
		},

		getGlobalEventBus: function () {
			return sap.ui.getCore().getEventBus();
		},

		onNavBack: function () {
			var oHistory = History.getInstance();
			var sPreviousHash = oHistory.getPreviousHash();

			if (sPreviousHash !== undefined) {
				window.history.back();
			} else {
				this.getRouter().navTo("RouteMain", {}, true);
			}
		},

		navToLaunchpad: function () {
			try {
				var oCrossAppNavigator = sap.ushell.Container.getService("CrossApplicationNavigation");
				oCrossAppNavigator.toExternal({
					target: {
						shellHash: "#"
					}
				});
			} catch (exc) {
				//do nothing
			}
		},

		navToOtherApp: function (sSemanticObject, sAction, oParams, oInAppNav) {
			if (sap.ushell && sap.ushell.Container && sap.ushell.Container.getService) {
				var appModel = this.getModel("appView");
				appModel.setProperty("/busy", true);
				var sIntent = sSemanticObject + "-" + sAction;
				window.setTimeout(function () {
					var oCrossAppNavigator = sap.ushell.Container.getService("CrossApplicationNavigation");
					oCrossAppNavigator.isIntentSupported([sIntent])
						.done(function (aResponses) {
							if (aResponses[sIntent].supported === true) {
								oCrossAppNavigator.toExternal({
									target: {
										semanticObject: sSemanticObject,
										action: sAction
									},
									appSpecificRoute: oInAppNav,
									params: oParams
								});
							} else {
								appModel.setProperty("/busy", false);
							}
						});
				}, 0);
			}
		},

		//Navigates to the first intent in the array that is supported
		navToIntents: function (aItents) {
			if (sap.ushell && sap.ushell.Container && sap.ushell.Container.getService) {
				var appModel = this.getModel("appView");
				appModel.setProperty("/busy", true);
				window.setTimeout(function () {
					var oCrossAppNavigator = sap.ushell.Container.getService("CrossApplicationNavigation");
					oCrossAppNavigator.isNavigationSupported(aItents)
						.done(function (aResponses) {
							for (var i = 0; i < aResponses.length; i++) {
								if (aResponses[i].supported === true) {
									oCrossAppNavigator.toExternal(
										aItents[i]);
									return;
								}
							}
							appModel.setProperty("/busy", false);
						});
				}, 0);
			}
		},

		getEmptyObjectFromEntity: function (sEntityName, oParameters) {
			var model = this.getModel("sap");
			var metadata = model.getServiceMetadata();
			var entity = metadata.dataServices.schema[0].entityType.filter(function (ent) {
				return ent.name === sEntityName;
			})[0];

			if (!entity) {
				return null;
			}

			var object = {};
			entity.property.forEach(function (property) {
				object[property.name] = this._getEmptyPropertyForType(property);
			}.bind(this));

			if (oParameters) {
				Object.keys(object).forEach(function (key) {
					if (oParameters.hasOwnProperty(key)) {
						object[key] = oParameters[key];
					}
				});
			}

			return object;
		},

		_getEmptyPropertyForType: function (oProperty) {
			switch (oProperty.type) {
			case "Edm.Decimal":
				return "0";
			case "Edm.DateTime":
				return new Date();
			case "Edm.String":
				return "";
			case "Edm.Float":
			case "Edm.Int16":
			case "Edm.Int32":
				return 0;
			case "Edm.Int64":
				return "0";
			case "Edm.Double":
				return 0;
			case "Edm.Boolean":
				return false;
			default:
				return "";
			}
		}
	});

});