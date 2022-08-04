/* some other codes */
'[extensibleFramework] [tabName=HDR][isTabView=true]': {
  afterlayout: function () {
    if (!EAM.Utils.getScreen().isScreenDesigner) {
      var vFormPanel = this.getFormPanel();
      if (EAM.Utils.getScreen().getCurrentTab().tabName == 'HDR') {
        /* some other codes */
        admin_fn(vFormPanel);
        /* some other codes */
      }
    }
  },
  afterrecordchange: function () {
    if (!EAM.Utils.getScreen().isScreenDesigner) {
      var vFormPanel = this.getFormPanel();
      if (EAM.Utils.getScreen().getCurrentTab().tabName == 'HDR') {
        /* some other codes */
        admin_fn(vFormPanel);
        /* some other codes */
      }
    }
  },
},
/* some other codes */
function admin_fn(vFormPanel) {
  try {
    var admin_function = vFormPanel.getFld('udfchar02');
    var mp_src = vFormPanel.getFld('udfchar03');
    var eq_src = vFormPanel.getFld('udfchar04');
    var eq_org_src = vFormPanel.getFld('udfchar05');
    // initial admin fn field
    mp_src.setReadOnly(true);
    eq_src.setReadOnly(true);
    eq_org_src.setReadOnly(true);

    // assign query on input change
    admin_function.inputEl.dom.onfocus = function () {
      var fn = this.value;
      if (fn == 'RSET') {
        mp_src.setValue('');
        mp_src.setReadOnly(true);
        eq_src.setReadOnly(false);
        eq_org_src.setReadOnly(false)
      }
      else if (fn == 'CPMP') {
        mp_src.setReadOnly(false);
        eq_src.setValue('');
        eq_src.setReadOnly(true);
        eq_org_src.setValue('');
        eq_org_src.setReadOnly(true)
      }
      else {
        mp_src.setValue('');
        mp_src.setReadOnly(true);
        eq_src.setValue('');
        eq_src.setReadOnly(true);
        eq_org_src.setValue('');
        eq_org_src.setReadOnly(true)
      }
    }
  }
  catch (err) { console.log('admin_fn'); console.log(err.toString()) }
}
