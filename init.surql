-- namespace の定義
define namespace mito;

-- database の定義
use ns mito;
define database njs;

-- userの定義
use db njs;
define user njs_user on database password "njs_user" roles owner;

-- メールメッセージテーブルの定義
DEFINE TABLE mail_messages SCHEMAFULL;
DEFINE FIELD id ON mail_messages TYPE string;
DEFINE FIELD subject ON mail_messages TYPE string ASSERT $value != NONE;
---- datetimeだとエラーになるのでstringにしている
DEFINE FIELD received_at ON mail_messages TYPE string ASSERT $value != NONE;
DEFINE FIELD body ON mail_messages TYPE string ASSERT $value != NONE;
DEFINE FIELD sender ON mail_messages TYPE string ASSERT $value != NONE;

-- メール受信者テーブルの定義
DEFINE TABLE mail_recipients SCHEMAFULL;
DEFINE FIELD id ON mail_recipients TYPE string;
DEFINE FIELD mail_message_id ON mail_recipients TYPE string ASSERT $value != NONE;
DEFINE FIELD recipient_type ON mail_recipients
  TYPE string
  ASSERT $value IN ['to', 'cc']
  VALUE $value OR NONE;
DEFINE FIELD email ON mail_recipients TYPE string ASSERT $value != NONE;

-- メール添付ファイルテーブルの定義
DEFINE TABLE mail_attachments SCHEMAFULL;
DEFINE FIELD id ON mail_attachments TYPE string;
DEFINE FIELD mail_message_id ON mail_attachments TYPE string ASSERT $value != NONE;
DEFINE FIELD file_path ON mail_attachments TYPE string ASSERT $value != NONE;

-- リレーションの定義
DEFINE FIELD recipients ON mail_messages TYPE array<record<mail_recipients>>;
DEFINE FIELD attachments ON mail_messages TYPE array<record<mail_attachments>>;
