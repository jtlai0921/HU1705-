﻿Type=Activity
Version=3
@EndOfDesignText@
#Region  Activity Attributes 
	#FullScreen: False
	#IncludeTitle: True
#End Region

Sub Process_Globals
    Dim SQLCmd As SQL                         '宣告SQL物件
    Dim CursorDBPoint As Cursor               '資料庫記錄指標
End Sub

Sub Globals
    '宣告輸入「課程資料表」的相關資料
	Dim edtCourNo As EditText           '課程代號
	Dim edtCourName As EditText         '課程名稱
	Dim edtCourCredits As EditText      '學分數
	
	'宣告SQL的DML(四種操作語言)
	Dim btnInsert As Button             '新增功能
	Dim btnUpdate As Button             '修改功能
	Dim btnDelete As Button             '刪除功能
	Dim btnSelect As Button             '查詢功能
	
	Dim SpinQueryCourNo As Spinner      '查詢「課程代號」
	Dim livCourse As ListView           '顯示「課程資料表」清單元件

	Dim btnListData As Button           '清單功能
	Dim btnExitCourse As Button         '離開功能
	
	'ListView清單元件中，用來顯示標頭欄位名稱、分隔分平線及記錄
	Dim strSqlViewTitle As String =""
	Dim strLine As String =""
	Dim strSqlViewContent As String =""
	Dim lblResult As Label
End Sub

Sub Activity_Create(FirstTime As Boolean)
	If SQLCmd.IsInitialized() = False Then  '判斷SQL物件是否已經初始化，如果沒有，則
        SQLCmd.Initialize(File.DirDefaultExternal, _
		"MyeSchoolDB.sqlite", True) '將SQL物件初始化資料庫
    End If
	Activity.LoadLayout("Course")
    Activity.Title ="【課程資料管理系統】"
	SpinQueryCourNo.Visible=False  '查詢「課程代號」的下拉式元件隱藏
	edtCourNo.Text="C006"
	edtCourName.Text="手機程式設計"
	edtCourCredits.Text="3"
	QueryDBList("Select * FROM 課程資料表")      '呼叫顯示「課程資料」全部記錄(多筆清單)
End Sub

Sub Activity_Resume

End Sub

Sub Activity_Pause (UserClosed As Boolean)

End Sub

Sub btnInsert_Click  '新增「課程資料」
 Dim strSQL As String
 Dim CourNo As String =edtCourNo.Text               '將「課程代號」欄位內容指定給變數
 Dim CourName As String = edtCourName.Text          '將「課程名稱」欄位內容指定給變數
 Dim CourCredits As String = edtCourCredits.Text    '將「學分數」欄位內容指定給變數
 strSQL = "INSERT INTO 課程資料表(課號,課名,學分數)" & _
             "VALUES('" & CourNo & "','" & CourName & "'" & _
			 ",'" & CourCredits & "')"
 SQLCmd.ExecNonQuery(strSQL)                        '執行SQL指令，以成功的新增記錄
 QueryDBList("Select * FROM 課程資料表")            '呼叫顯示「課程資料」全部記錄(多筆清單)
End Sub

Sub btnUpdate_Click   '修改「課程資料」
   Dim strSQL As String
   Dim CourNo As String =edtCourNo.Text
   strSQL = "UPDATE 課程資料表" & _
            " SET 課名 ='" & edtCourName.Text & "'" & _
            ",學分數 ='" & edtCourCredits.Text & "'" & _
			" WHERE 課號 = '" & CourNo & "'"
   SQLCmd.ExecNonQuery(strSQL)
   QueryDBList("Select * FROM 課程資料表")            '呼叫顯示「課程資料」全部記錄(多筆清單)
End Sub

Sub btnDelete_Click   '刪除「課程資料」
   Dim strSQL As String
   Dim CourNo As String =edtCourNo.Text
   strSQL = "DELETE FROM 課程資料表 WHERE 課號 = '" & CourNo & "'"
   SQLCmd.ExecNonQuery(strSQL)
   QueryDBList("Select * FROM 課程資料表")           '呼叫顯示「課程資料」全部記錄(多筆清單)
End Sub

Sub btnSelect_Click   '查詢「課程資料」
    SpinQueryCourNo.Visible =True    '查詢「課程代號」的下拉式元件顯示
	edtCourNo.Visible =False         '「課程代號」欄位元件隱藏
    SpinQueryCourNo.Clear            '查詢「課程代號」的下拉式元件來清空
    CursorDBPoint = SQLCmd.ExecQuery("SELECT 課號 FROM 課程資料表")
    For i = 0 To CursorDBPoint.RowCount - 1
        CursorDBPoint.Position = i     '設定開始游標指定第一筆記錄
		SpinQueryCourNo.Add(CursorDBPoint.GetString("課號"))
    Next
End Sub

Sub SpinQueryCourNo_ItemClick (Position As Int, Value As Object)
	Dim SQL_Query As String
	Dim QueryCourNo As String =SpinQueryCourNo.SelectedItem
	SQL_Query="Select * FROM 課程資料表" & _
	          " Where 課號 = '" & QueryCourNo & "'"
	CallShow_CourseData(SQL_Query)    '呼叫顯示「課程資料表」之副程式
	SpinQueryCourNo.Visible =False    '查詢「課程代號」的下拉式元件隱藏
	edtCourNo.Visible =True           '「課程代號」欄位元件顯示
End Sub

Sub CallShow_CourseData(strSQL As String)  '顯示「課程資料表」之副程式
	CursorDBPoint = SQLCmd.ExecQuery(strSQL)
    CursorDBPoint.Position = 0
	edtCourNo.Text = CursorDBPoint.GetString("課號")
    edtCourName.Text=CursorDBPoint.GetString("課名")
    edtCourCredits.Text=CursorDBPoint.GetString("學分數")
End Sub

Sub QueryDBList(strSQLite As String)
    livCourse.Clear '清單清空
	strSqlViewTitle =""
	strSqlViewContent =""
	strLine =""
    CursorDBPoint = SQLCmd.ExecQuery(strSQLite)
	livCourse.SingleLineLayout.Label.TextSize=14
	livCourse.SingleLineLayout.ItemHeight = 16dip
	For i = 0 To CursorDBPoint.ColumnCount-1    '取得「欄位名稱」
	    strSqlViewTitle=strSqlViewTitle & _
		CursorDBPoint.GetColumnName(i) & "      " 
		strLine=strLine & "======"              '設定「分隔水平線之每一小段的長度」
	Next	
    livCourse.AddSingleLine (strSqlViewTitle)   '顯示「欄位名稱」
    livCourse.AddSingleLine (strLine)           '顯示「分隔水平線」
    For i = 0 To CursorDBPoint.RowCount - 1     '控制「記錄」的筆數
        CursorDBPoint.Position = i              '記錄指標從第1筆開始(索引為0)
      For j=0 To CursorDBPoint.ColumnCount-1    '控制「欄位」的個數
	     strSqlViewContent=strSqlViewContent & CursorDBPoint.GetString(CursorDBPoint.GetColumnName(j)) & "  "
	  Next	
	  	 livCourse.AddSingleLine ((i+1) & ". " & strSqlViewContent )   '顯示「每一筆記錄的內容」
		 strSqlViewContent =""
	Next	
    ToastMessageShow("目前的課程記錄共有: " & CursorDBPoint.RowCount & " 筆!",False)
	lblResult.Text ="===本學期開設課程清單( " & CursorDBPoint.RowCount & " 筆)==="
End Sub

Sub btnListData_Click
	QueryDBList("Select * FROM 課程資料表")
End Sub
Sub btnExitCourse_Click
	Activity.Finish()  '活動完成
	StartActivity(Main)
End Sub