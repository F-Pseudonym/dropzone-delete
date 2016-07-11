# Dropzone Action Info
# Name: Delete
# Description: Immediately delete files or folders\n(Icon by zlmimi on openclipart.org)
# Handles: Files
# Creator: Florian Scheuer
# URL: https://github.com/F-Pseudonym/dropzone-delete
# Events: Dragged
# SkipConfig: Yes
# RunsSandboxed: No
# Version: 1.0
# MinDropzoneVersion: 3.0

require 'fileutils'


def dragged
  
  $dz.determinate(false)
  
  if $items.count == 1
    question = "\"#{File.basename $items[0]}\""
  else
    question = "#{$items.count} objects"
  end
  
  output = $dz.cocoa_dialog("yesno-msgbox --no-cancel --text 'Permanently delete #{question}?'")
  if output == "1\n"
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
    # NO
    $dz.finish("Canceled")
  end

  $dz.url false
  
end

