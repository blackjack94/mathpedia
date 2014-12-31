$(function() {
  $('.editable').each(function(){
    //params for customized editor
    var params = {
      placeholder: $(this).attr('placeholder'),
      buttonLabels: 'fontawesome',
      buttons: ['bold', 'italic', 'underline', 'header1', 'header2', 'justifyCenter', 'justifyFull', 'unorderedlist', 'orderedlist']
    }

    //initialize the editor
    $('<div id="text_editable" class="editable">' + $(this).html() + '</div>').replaceAll(this);
    var editor = new MediumEditor('.editable', params);

    //add insert functionality
    $('.editable').mediumInsert({
      editor: editor,
      addons: {
        images: {
          imagesUploadScript: "/assets",
          deleteFile: function(file, that) {
            var fileParts = file.split("/");
            var id = fileParts[fileParts.length - 2];
            $.ajax({
              type: "delete",
              url: "/assets/" + id
            });
          }
        }
      }
    });

    //serialize content to hidden_field on SUBMIT
    $( "#lean_editor" ).submit(function( event ) {
      $('#text_field').val(editor.serialize().text_editable.value);
    });

    //serialize content to modal on PREVIEW
    $('#preview_button').click(function(e){
      e.preventDefault();

      $('#preview_body').html(editor.serialize().text_editable.value);
      $('#preview_modal').modal('show');
    });
  });

  //fill in content-editable if there are any errors?
  var text = $('#text_field').val();
  if (text.length != 0) {
    $('#text_editable').removeAttr('data-placeholder');
    $('#text_editable').html(text);
  }

  //enable MathJax preview in .editable
  $('.editable').writemaths({position:'center top', previewPosition: 'center bottom', of: 'this'});

  //Typesetting on PREVIEW
  $('#preview_modal').on('show.bs.modal', function (e) {
    MathJax.Hub.Queue(["Typeset",MathJax.Hub]);
  });
});