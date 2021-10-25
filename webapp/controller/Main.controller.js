sap.ui.define([
	"./BaseController"
],
	/**
	 * @param {typeof sap.ui.core.mvc.Controller} Controller
	 */
	function (Controller) {
		"use strict";

		return Controller.extend("be.dimensys.assetperformance.assetperformance.controller.Main", {
			onInit: function () {

			},

			press: function (oEvent) {
				
			},
			pressIAM: function (oEvent) {
				this.getRouter().navTo("iam");
			},

		});
	});
