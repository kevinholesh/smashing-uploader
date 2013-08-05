jQuery ->

  uploadingCount = 0

  # Activate jQuery File Upload
  $("#new_photo").S3Uploader
    before_add: (file) ->
      types = /(\.|\/)(gif|jpe?g|png)$/i
      if types.test(file.type) || types.test(file.name)
        uploadingCount++
        window.loadImage(
          file
          (img) ->
            $("##{file.unique_id} .image").html(img)
        )
        return true
      else
        $('ul.errors').append($('<li>').text("#{file.name} is not a gif, jpeg, or png image file so it wasn't uploaded"))
        return false
    progress_bar_target: $('.photos .new')
    remove_completed_progress_bar: false

  # When a photo is done uploading
  $('#new_photo').bind "s3_upload_complete", (e, content) ->
    $('.photos').find("##{content.unique_id}").toggleClass('uploading done')
  
  # When a photo upload fails
  $('#new_photo').bind "s3_upload_failed", (e, content) ->
    $('ul.errors').append($('<li>').text("Error uploading photo: #{content.error_thrown}"))
  
  # When a photo upload succeeds
  $('#new_photo').bind "ajax:success", (e, data) ->
    uploadingCount--


  # Make the upload form look droppable
  $('#new_photo').bind 'dragover', (e) ->
    $dumbo = $(this)
    timeout = window.dropZoneTimeout
    clearTimeout(timeout) if timeout
  
    if e.target == $dumbo[0]
      $dumbo.addClass('dragover')
    else
      $dumbo.removeClass('dragover')
    window.dropZoneTimeout = setTimeout ->
      window.dropZoneTimeout = null
      $dumbo.removeClass('dragover')
    , 100
  
  $(document).bind 'drop dragover', (e) ->
    e.preventDefault()
  
  
  # Warn the person if they still have photos uploading and they try to close the page
  window.onbeforeunload = ->
    if uploadingCount > 0
      "You still have photos uploading. Leaving this page will cancel those uploads."