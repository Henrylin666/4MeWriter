; ��װ�����ʼ���峣��
!define PRODUCT_NAME "Clear Writer"
!define PRODUCT_VERSION "1.7"
!define PRODUCT_PUBLISHER "�ֺ�ƽ"
!define PRODUCT_DIR_REGKEY "Software\Microsoft\Windows\CurrentVersion\App Paths\clear_writer.exe"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"

SetCompressor lzma

; ------ MUI �ִ����涨�� (1.67 �汾���ϼ���) ------
!include "MUI.nsh"
!include "WinMessages.nsh"


; MUI Ԥ���峣��
!define MUI_ABORTWARNING
!define MUI_ICON "icon.ico"
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\modern-uninstall.ico"

!define MUI_WELCOMEFINISHPAGE_BITMAP "brand.bmp"
!define MUI_WELCOMEPAGE_TITLE "\r\n������$(^NameDA) ��װ����"
!define MUI_WELCOMEPAGE_TEXT "Clear Writer ��һ����� Markdown д�������������һ��������д������\r\n\r\n���ߣ��ֺ�ƽ\r\n\r\n$_CLICK"

; ����ѡ�񴰿ڳ�������
!define MUI_LANGDLL_REGISTRY_ROOT "${PRODUCT_UNINST_ROOT_KEY}"
!define MUI_LANGDLL_REGISTRY_KEY "${PRODUCT_UNINST_KEY}"
!define MUI_LANGDLL_REGISTRY_VALUENAME "NSIS:Language"


; ��ӭҳ��
!define MUI_PAGE_CUSTOMFUNCTION_SHOW ChangeFont
!insertmacro MUI_PAGE_WELCOME
; ���Э��ҳ��
!define MUI_LICENSEPAGE_CHECKBOX

!define MUI_PAGE_CUSTOMFUNCTION_SHOW ChangeFont
!insertmacro MUI_PAGE_LICENSE "description.txt"

; ��װĿ¼ѡ��ҳ��
!define MUI_PAGE_CUSTOMFUNCTION_SHOW ChangeFont
!insertmacro MUI_PAGE_DIRECTORY
; ��װ����ҳ��
!insertmacro MUI_PAGE_INSTFILES
; ��װ���ҳ��
!define MUI_FINISHPAGE_RUN "$INSTDIR\clear_writer.exe"
!insertmacro MUI_PAGE_FINISH

; ��װж�ع���ҳ��
!insertmacro MUI_UNPAGE_INSTFILES

; ��װ�����������������
!insertmacro MUI_LANGUAGE "SimpChinese"

; ��װԤ�ͷ��ļ�
!insertmacro MUI_RESERVEFILE_LANGDLL
!insertmacro MUI_RESERVEFILE_INSTALLOPTIONS

; ------ MUI �ִ����涨����� ------

Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "${PRODUCT_NAME}_${PRODUCT_VERSION}_setup.exe"
InstallDir "$PROGRAMFILES\Clear Writer"
InstallDirRegKey HKLM "${PRODUCT_UNINST_KEY}" "UninstallString"
ShowInstDetails show
ShowUnInstDetails show
BrandingText "Simple. Beautiful. Powerful."

Section "MainSection" SEC01
  SetOutPath "$INSTDIR"
  SetOverwrite ifnewer
  
  File /r "OutApp\clear_writer-win32-x64\*.*"
  
  CreateShortCut "$SMPROGRAMS\Clear Writer.lnk" "$INSTDIR\clear_writer.exe"
  CreateShortCut "$DESKTOP\Clear Writer.lnk" "$INSTDIR\clear_writer.exe"
SectionEnd

Section -Post
  WriteUninstaller "$INSTDIR\uninst.exe"
  WriteRegStr HKLM "${PRODUCT_DIR_REGKEY}" "" "$INSTDIR\clear_writer.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayIcon" "$INSTDIR\clear_writer.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
SectionEnd

#-- ���� NSIS �ű��༭�������� Function ���α�������� Section ����֮���д���Ա��ⰲװ�������δ��Ԥ֪�����⡣--#

Function .onInit
  System::Call 'SHCore::SetProcessDpiAwareness(i 1)i.R0'
  !insertmacro MUI_LANGDLL_DISPLAY
FunctionEnd

Function ChangeFont
	FindWindow $0 "#32770" "" $HWNDPARENT ;$0 ���������ھ��

	GetDlgItem $R0 $0 1006
	CreateFont $R1 "΢���ź�" 9 0 ;��װĿ¼ѡ��ҳ�� ����
	SendMessage $R0 ${WM_SETFONT} $R1 0

FunctionEnd

/******************************
 *  �����ǰ�װ�����ж�ز���  *
 ******************************/

Section Uninstall
  Delete "$INSTDIR\uninst.exe"
  Delete "$INSTDIR\clear_writer.exe"

  Delete "$DESKTOP\Clear Writer.lnk"
  Delete "$SMPROGRAMS\Clear Writer.lnk"

  RMDir "$SMPROGRAMS\Clear Writer"

  RMDir /r "$INSTDIR\swiftshader"
  RMDir /r "$INSTDIR\resources"
  RMDir /r "$INSTDIR\locales"

  RMDir "$INSTDIR"

  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  DeleteRegKey HKLM "${PRODUCT_DIR_REGKEY}"
  SetAutoClose true
SectionEnd

#-- ���� NSIS �ű��༭�������� Function ���α�������� Section ����֮���д���Ա��ⰲװ�������δ��Ԥ֪�����⡣--#

Function un.onInit
	System::Call 'SHCore::SetProcessDpiAwareness(i 1)i.R0'
	!insertmacro MUI_UNGETLANGUAGE
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "��ȷʵҪ��ȫж�� $(^Name) ��" IDYES +2
  Abort
FunctionEnd

Function un.onUninstSuccess
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) �ѳɹ��ش����ļ�����Ƴ����ڴ�������´μ��档"
FunctionEnd
