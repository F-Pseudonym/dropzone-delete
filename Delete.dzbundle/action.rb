# Dropzone Action Info
# Name: Delete
# Description: Immediately delete files or folders\n(Icon by zlmimi on openclipart.org)
# Handles: Files
# Creator: Florian Scheuer
# URL: https://github.com/F-Pseudonym/dropzone-delete
# Events: Dragged
# SkipConfig: Yes
# RunsSandboxed: No
# Version: 1.1
# MinDropzoneVersion: 3.0

require 'fileutils'


def dragged
  
  $dz.determinate(false)
  
  if $items.count == 1
    question = "\"#{File.basename $items[0]}\""
  else
    question = "#{$items.count} objects"
  end

  # pashua config string
  config = <<-EOS
  
  # Set window title
  *.title = Delete
  # question
  txt.type = text
  txt.default = Permanently delete #{question}?
  txt.tooltip = All items will be permanently deleted.
  # buttons
  cb.type = cancelbutton
  cb.tooltip = Cancel
  db.type = defaultbutton
  db.tooltip = Ok
  
  EOS
  
  res = pashua_run(config)
  if res["db"] == "1"
    # YES
    $items.each do |item|
      begin
        if File.directory? item
          FileUtils.rm_rf item
        else
          File.delete item
        end
      rescue
        $dz.fail("Error deleting #{item}.")
      end
    end
    $dz.finish("Success!")    
    
  else
    # ensure no
    if res["cb"] == "1"
      # NO
      $dz.finish("Canceled")
    end
  end

  $dz.url false
  
end