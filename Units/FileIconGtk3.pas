unit FileIconGtk3;
{$mode objfpc}{$H+}

interface
uses
  Classes, SysUtils, Graphics,
  FileIcon,
  LazGio2, LazGlib2,
  LazGTK3;


type TFileIconGtk = class(TFileIconAdapter)
protected
  function getIconByNameGtk(icon_name:Pgchar; size:integer):TIcon;
  function getIconByName( iconName:string; size:integer):TIcon;
  function getIconNameForFile(filename:string; size:integer):string; override;
  function getIconForFile(filename:string; size:integer):TIcon; override;
  function getIconNamesForFileGtk3(filename:string; size:integer):PPgchar;
public
  function addIconsForFile(filename:string):integer; override;
end;

implementation

function TFileIconGtk.getIconByNameGtk(icon_name:Pgchar; size:integer):TIcon;
var icon_filename: Pgchar;
    iconFileName: string;
begin
  result := nil;
  {icon_theme := gtk3_icon_theme_get_default;
  if gtk_icon_theme_has_icon(icon_theme, icon_name) then
  begin
       icon_info := gtk_icon_theme_lookup_icon( icon_theme, icon_name, size,
                                                GTK_ICON_LOOKUP_NO_SVG);
       icon_filename := gtk_icon_info_get_filename(icon_info);
       iconFileName := String(icon_filename);
       result := LoadIconFromFile(iconFileName);
  end;}
end;

function TFileIconGtk.getIconByName( iconName:string; size:integer):TIcon;
begin
  result := getIconByNameGtk(PChar(iconName), size);
end;

function TFileIconGtk.getIconNameForFile(filename:string; size:integer):string;
var icon_theme: PGtkIconTheme;  icon_names:PPgchar; icon_name:Pgchar; i:integer;
begin
  result := '';
  icon_names := getIconNamesForFileGtk3(filename, size);
  icon_theme := gtk_icon_theme_get_default;
  for i:=0 to (sizeOf(icon_names) div sizeOf(Pgchar))-1 do
  begin
      icon_name := icon_names[i];
      if gtk_icon_theme_has_icon(icon_theme, icon_name) then
      begin
         result := String(icon_name);
         break;
      end;
  end;
end;

function TFileIconGtk.getIconForFile(filename:string; size:integer):TIcon;
var icon:TIcon;
    file_name: Pgchar;
    file_info: PGFileInfo;
    gfile : PGFile;
    flags: TGFileQueryInfoFlags;
    cancellable: PGCancellable;
    error: PGError;
    gicon : PGIcon;
    gimage: PGtkImage;
begin
  result := nil;
  file_name := PChar(filename);
  gfile := g_file_new_for_path(file_name);
  cancellable:= TGCancellable.new;
  flags := G_FILE_QUERY_INFO_NONE;
  error := new(PGError);
  file_info := g_file_query_info(gfile, 'standard::icon', flags, cancellable, @error);
  gicon := g_file_info_get_icon(file_info);
  gimage := gtk_image_new_from_gicon(gicon, size);
  //result := gimage;
end;

// checks if icon is already cached and adds an icon if it is not cached,
// returns icon index in LargeIconList and SmallIconList
function TFileIconGtk.addIconsForFile(filename:string):integer;
var //mimeType:string;
    iconName:string; i,i1,i2,iconIndex:integer;
    smallIcon, largeIcon: TIcon;
begin
  result := -1;
  iconName := getIconNameForFile(filename,16);

  // check if icon is registered in iconName to IconIndex map
  i := FIconNamesMap.IndexOf(iconName);
  if (i>-1) then
    begin
    iconIndex := PtrUInt(FIconNamesMap.Objects[i]);
    result := iconIndex;
    end
  else
    begin
    iconIndex := -1;
    smallIcon := getIconByName(iconName,16);
    largeIcon := getIconByName(iconName,32);
    if assigned(smallIcon) and assigned(largeIcon) then
      begin
      i1 := FSmallImageList.AddIcon(smallIcon);
      i2 := FLargeImageList.AddIcon(largeIcon);
      iconIndex := i1;
      FIconNamesMap.AddObject(iconName, TObject(PtrUint(iconIndex)));
      result := iconIndex;
      end;
    end;
end;

function TFileIconGtk.getIconNamesForFileGtk3(filename:string; size:integer):PPgchar;
var file_name: Pgchar;
    file_info: PGFileInfo;
    gfile : PGFile;
    flags: TGFileQueryInfoFlags;
    cancellable: PGCancellable;
    error: PGError;
    gicon : PGIcon;
    gicon_str: Pgchar;
begin
  result := nil;
  file_name := PChar(filename);
  gfile := g_file_new_for_path(file_name);
  cancellable:= TGCancellable.new;
  flags := G_FILE_QUERY_INFO_NONE;
  error := new(PGError);
  file_info := g_file_query_info(gfile, 'standard::icon', flags, cancellable, @error);
  gicon := g_file_info_get_icon(file_info);
  // There is no other way to get a type of gicon. workaround is to get it from string.
  // it can be GBytesIcon, GEmblem, GEmblemedIcon, GFileIcon and GThemedIcon.
  // for now we expect just GThemedIcon
  gicon_str := gicon^.to_string;
  if strlcomp(gicon_str, '. GThemedIcon',11) = 0 then
     result := (PGThemedIcon(gicon))^.get_names
  else
     begin
     GetMem(result, sizeof(Pgchar));
     result[0] := gicon_str;
     end;
  //else
  //   raise Exception.create('Unknown icon string:"'+String(gicon_str)+'"');
end;


end.

