PATTERN = "Simplified Robot - "
REPLACEMENT = ""
DIRECTORY = ".\"


Set objFso = CreateObject("Scripting.FileSystemObject")
Set Folder = objFSO.GetFolder(DIRECTORY)

For Each File In Folder.Files
    sNewFile = File.Name
    sNewFile = Replace(sNewFile, PATTERN, REPLACEMENT)

    if (sNewFile<>File.Name) then

        File.Move(File.ParentFolder + "\" + sNewFile)
    end if
Next