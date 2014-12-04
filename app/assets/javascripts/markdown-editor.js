$(document).ready(function() {
	window.editor = {
		
		// Editor variables
		fitHeightElements: $(".markdown-editor"),
		wrappersMargin: $("#left-column > .wrapper:first").outerHeight(true) - $("#left-column > .wrapper:first").height(),
		markdownConverter: marked,
		columns: $(".mde-left-column, .mde-right-column"),
		markdownSource: $(".mde-editor"),
		markdownHTML: $(".mde-html"),
		markdownPreview: $(".mde-preview"),
		titleSource: $('#content_title'),
		titlePreview: $('.mde-preview-title'),
		titleHTML: $('.mde-html-title'),
		saveButton: $('#save-content'),
		isAutoScrolling: false,
		unsaved: false,
		autosaveLocation: window.location.href + '.json',
		savedSource: "",
		
		// Initiate editor
		init: function() {
			this.initBindings();
			this.fitHeight();
			if (this.markdownSource.val() != "") this.savedSource = this.convertMarkdown();
			if (this.titleSource.val() != "") this.displayTitle();
			this.autosave();
			// this.restoreState(function() {
			// 	editor.convertMarkdown();
			// 	editor.onloadEffect(1);
			// });
		},

		// Handle events on several DOM elements
		initBindings: function() {
			$(window).on("resize", function() {
				editor.fitHeight();
			});
			this.markdownSource.on({
				keydown: function(e) {
					if (e.keyCode == 9) {
						editor.handleTabKeyPress(e);
					}
				},
				"keyup change": function() {
					editor.markdownSource.trigger("change.editor");
				},
				"cut paste drop": function() {
					setTimeout(function() {
						editor.markdownSource.trigger("change.editor");
					}, 0);
				},
				"change.editor": function() {
					editor.displayUnsavedMode();
					editor.convertMarkdown();
				}
			});
			this.titleSource.on({
				"keyup change": function() {
					editor.unsaved = true;
					editor.titleSource.trigger("change.title");
				},
				"cut paste drop": function() {
					setTimeout(function() {
						editor.unsaved = true;
						editor.titleSource.trigger("change.title");
					}, 0);
				},
				"change.title": function() {
					editor.displayUnsavedMode();
					editor.displayTitle();
				}
			});
			this.saveButton.on({
				click: function() {
					editor.startingSave();
				}
			});
		},

		// Resize some elements to make the editor fit inside the window
		fitHeight: function() {
			var newHeight = $(window).height() - this.wrappersMargin;
			this.fitHeightElements.each(function() {
				var t = $(this);
				// if (t.closest("#left-column").length) {
				// 	var thisNewHeight = newHeight - $("#top_panels_container").outerHeight();
				// } else {
				var thisNewHeight = newHeight;
				// }
				t.css({ height: thisNewHeight +"px" });
			});
		},

		autosave: function() {
			setInterval($.proxy(function() {
				if (editor.savedSource !== editor.markdownSource.val() || this.unsaved) {
					editor.startingSave();
					$.ajax({
						url: editor.autosaveLocation,
						type: 'put',
						dataType: 'json',
						data: editor.markdownSource.parents("form.edit_content").serialize(),
						success: $.proxy(function(data) {
							editor.successfulSave();
							editor.unsaved = false;
						}, this)
					});
				}
			}, this), 60000);
		},

		startingSave: function() {
	    $('#save-content').removeClass('csw-font-review, csw-font-ready');
	    $('#save-content .csw-save-text').html("Saving...");
	  },

	  successfulSave: function() {
	    $('#save-content').removeClass('csw-font-review').addClass('csw-font-ready');
	    $('#save-content .csw-save-text').html("Saved");
	    editor.savedSource = editor.markdownSource.val();
	  },

	  displayUnsavedMode: function() {
	    $('#save-content').removeClass('csw-font-ready').addClass('csw-font-review');
	    $('#save-content .csw-save-text').html("Not saved");
	  },

		// Convert Markdown to HTML using showdown.js
		convertMarkdown: function() {
			var markdown = this.markdownSource.val(),
				html = this.markdownConverter(markdown);
			this.markdownHTML.html(html);
			this.markdownPreview.html(html);
			// this.markdownPreview.trigger("updated.editor");
			return markdown;
		},

		displayTitle: function() {
			var title = '<h1>' + this.titleSource.val() + '</h1>';
			this.titleHTML.html(title);
			this.titlePreview.html(title);
		},

		// Programmatically add Markdown text to the textarea
		// position = { start: Number, end: Number }
		addToMarkdownSource: function(markdown, position) {
			var markdownSourceValue = this.markdownSource.val();
			if (typeof(position) == "undefined") { // Add text at the end
				var newMarkdownSourceValue =
					(markdownSourceValue.length? markdownSourceValue + "\n\n" : "") +
					markdown;
			} else { // Add text at a given position
				var newMarkdownSourceValue =
					markdownSourceValue.substring(0, position.start) +
					markdown +
					markdownSourceValue.substring(position.end);
			}
			this.markdownSource
				.val(newMarkdownSourceValue)
				.trigger("change.editor");
		},

		// Switch between editor panels
		switchToPanel: function(which) {
			var target = $("#"+ which),
				targetTrigger = this.markdownTargetsTriggers.filter("[data-switchto="+ which +"]");
			if (!this.isFullscreen || which != "markdown") this.markdownTargets.not(target).hide();
			target.show();
			this.markdownTargetsTriggers.not(targetTrigger).removeClass("active");
			targetTrigger.addClass("active");
			if (which != "markdown") this.featuresTriggers.filter("[data-feature=fullscreen][data-tofocus]").last().data("tofocus", which);
			if (this.isFullscreen) {
				var columnToShow = (which == "markdown")? this.markdownSource.closest(this.columns) : this.markdownPreview.closest(this.columns);
				columnToShow.show();
				this.columns.not(columnToShow).hide();
			}
			if (this.isAutoScrolling && which == "preview") {
				this.markdownPreview.trigger("updated.editor"); // Auto-scroll on switch since it wasn't possible earlier due to the preview being hidden
			}
			this.save("activePanel", which);
		},

		// Toggle a top panel's visibility
		// toggleTopPanel: function(panel) {
		// 	if (panel.is(":visible")) this.closeTopPanels();
		// 		else this.openTopPanel(panel);
		// },

		// Open a top panel
		// openTopPanel: function(panel) {
		// 	var panelTrigger = this.topPanelsTriggers.filter("[data-toppanel="+ panel.attr("id") +"]");
		// 	panel.show();
		// 	panelTrigger.addClass("active");
		// 	this.topPanels.not(panel).hide();
		// 	this.topPanelsTriggers.not(panelTrigger).removeClass("active");
		// 	this.fitHeight();
		// 	$(document).off("keyup.toppanel").on("keyup.toppanel", function(e) { // Close top panel when the escape key is pressed
		// 		if (e.keyCode == 27) editor.closeTopPanels();
		// 	});
		// },

		// Close all top panels
		// closeTopPanels: function() {
		// 	this.topPanels.hide();
		// 	this.topPanelsTriggers.removeClass("active");
		// 	this.fitHeight();
		// 	$(document).off("keyup.toppanel");
		// },

		// Insert a tab character when the tab key is pressed (instead of focusing the next form element)
		// Doesn't work in IE<9
		handleTabKeyPress: function(e) {
			var markdownSourceElement = this.markdownSource[0],
				tabInsertPosition = {
					start: markdownSourceElement.selectionStart,
					end: markdownSourceElement.selectionEnd
				};
			if (typeof(tabInsertPosition.start) == "number" && typeof(tabInsertPosition.end) == "number") {
				e.preventDefault();
				this.addToMarkdownSource("\t", tabInsertPosition);
				var cursorPosition = tabInsertPosition.start + 1;
				markdownSourceElement.setSelectionRange(cursorPosition, cursorPosition);
			}
		}
		
	};

	var csrf_token = $('meta[name=csrf-token]').attr('content');
  var csrf_param = $('meta[name=csrf-param]').attr('content');
  var params, interval;
  if (csrf_param !== undefined && csrf_token !== undefined) {
    params = csrf_param + '=' + encodeURIComponent(csrf_token);
  }

	if ($('.markdown-editor').length) window.editor.init();

});