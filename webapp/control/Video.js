sap.ui.define(["sap/ui/core/Control"], function (Control) {
	"use strict";
	return Control.extend("be.dimensys.assetperformance.assetperformance.control.Video", {
		"metadata": {
			"properties": {
				"src": "string",
				"width": "string",
				"type": "string"
			},
			"events": {}
		},
		init: function () {},
		onAfterRendering: function (evt) {},
		setSrc: function (value) {
			this.setProperty("src", value, false);
			return this;
		},
		setType: function (value) {
			this.setProperty("type", value, true);
			return this;
		},
		setWidth: function (value) {
			this.setProperty("width", value, true);
			return this;
		}
	});
});