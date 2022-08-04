/* some other codes */
'[extensibleFramework] [tabName=HDR][isTabView=true]': {
  afterlayout: function () {
    if (!EAM.Utils.getScreen().isScreenDesigner) {
      var vFormPanel = this.getFormPanel();
      if (EAM.Utils.getScreen().getCurrentTab().tabName == 'HDR') {
        /* some other codes */
        inactive_init(vFormPanel);
        /* some other codes */
      }
    }
  },
  afterrecordchange: function () {
    if (!EAM.Utils.getScreen().isScreenDesigner) {
      var vFormPanel = this.getFormPanel();
      if (EAM.Utils.getScreen().getCurrentTab().tabName == 'HDR') {
        /* some other codes */
        inactive_init(vFormPanel);
        /* some other codes */
      }
    }
  },
},
/* some other codes */
function inactive_init(vFormPanel) {
  try { vFormPanel.getFld('udfchkbox04').setReadOnly(true) }
  catch (err) { console.log('inactive_init'); console.log(err.toString()) }
}
