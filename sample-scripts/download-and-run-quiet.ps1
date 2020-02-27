$downloadURL = ""
Invoke-WebRequest -Uri $downloadURL -OutFile "C:\tmp\<downloadedfilename>"
Start-Process -FilePath "C:\tmp\<downloadedfilename>" -ArgumentList "/q"