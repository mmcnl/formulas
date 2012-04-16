var Formulas = {
  initialize: function() {
    $(':text:first').focus();
    Formulas.enablePopovers();
    $('input.query-data').change(Formulas.updateResults);
    $('#reset').click(Formulas.resetForm);
  },
  enablePopovers: function() {
    $('.pop').popover({placement: 'top', animation: true, trigger: 'hover'});
  },
  updateResults: function() {
    $('#results-table-div').load( '/?js=1',                      // remote url target
                                  $('#search-form').serialize(), // form data to send
                                  Formulas.enablePopovers );     // must reset after ajax update
  },
  resetForm: function() {
    $('#results-table-div').html('');
    $('input.query-data').val('');
    $(':text:first').focus();
  }
};

$(document).ready(Formulas.initialize);
