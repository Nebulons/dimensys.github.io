sap.ui.define([
	"./BaseController"
],
	/**
	 * @param {typeof sap.ui.core.mvc.Controller} Controller
	 */
	function (Controller) {
		"use strict";

		return Controller.extend("be.dimensys.assetperformance.assetperformance.controller.FSMScheduling", {
			onInit: function () {

			},
			onNavBack: function (oEvent) {
				this.getRouter().navTo("RouteMain", {}, true);
			},
		});
	});
