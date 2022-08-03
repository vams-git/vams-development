'[extensibleFramework] [tabName=HDR][isTabView=true]': {
  afterlayout: function () {
    if (!EAM.Utils.getScreen().isScreenDesigner) {
      var vFormPanel = this.getFormPanel();
      if (EAM.Utils.getScreen().getCurrentTab().tabName == 'HDR') {
        // if only on HDR
        FormPanel.getFld('udfchkbox04').setReadOnly(true)
      }
      /*
      SOME OTHER CODES
      */
    }
  },
  afterrecordchange: function () {
    if (!EAM.Utils.getScreen().isScreenDesigner) {
      var vFormPanel = this.getFormPanel();
      if (EAM.Utils.getScreen().getCurrentTab().tabName == 'HDR') {
        // if only on HDR
        FormPanel.getFld('udfchkbox04').setReadOnly(true)
      }
      /*
      SOME OTHER CODES
      */
    }
  },
},
