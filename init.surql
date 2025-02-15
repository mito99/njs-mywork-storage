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
DEFINE FIELD mail_date ON mail_messages TYPE string ASSERT $value != NONE;
DEFINE FIELD body ON mail_messages TYPE string ASSERT $value != NONE;

-- メール送信者テーブルの定義
DEFINE TABLE mail_senders SCHEMAFULL;
DEFINE FIELD id ON mail_senders TYPE string;
DEFINE FIELD message_id ON mail_senders TYPE string ASSERT $value != NONE;
DEFINE FIELD email ON mail_senders TYPE string ASSERT $value != NONE;

-- メール受信者テーブルの定義
DEFINE TABLE mail_recipients SCHEMAFULL;
DEFINE FIELD id ON mail_recipients TYPE string;
DEFINE FIELD message_id ON mail_recipients TYPE string ASSERT $value != NONE;
DEFINE FIELD recipient_type ON mail_recipients
  TYPE string
  ASSERT $value IN ['to', 'cc']
  VALUE $value OR NONE;
DEFINE FIELD email ON mail_recipients TYPE string ASSERT $value != NONE;

-- メール添付ファイルテーブルの定義
DEFINE TABLE mail_attachments SCHEMAFULL;
DEFINE FIELD id ON mail_attachments TYPE string;
DEFINE FIELD message_id ON mail_attachments TYPE string ASSERT $value != NONE;
DEFINE FIELD file_path ON mail_attachments TYPE string ASSERT $value != NONE;

-- メールコンタクトテーブルの定義
DEFINE TABLE mail_contacts SCHEMAFULL;
DEFINE FIELD id ON mail_contacts TYPE string; #email
DEFINE FIELD name ON mail_contacts TYPE string;

-- リレーションの定義
-- sender のリレーション
DEFINE FIELD sender ON mail_messages TYPE record<mail_senders>;
RELATE mail_messages:sender -> mail_senders ON mail_messages.id= mail_senders.message_id;
-- recipients のリレーション
DEFINE FIELD recipients ON mail_messages TYPE array<record<mail_recipients>>;
RELATE mail_messages:recipients -> mail_recipients ON mail_messages.id = mail_recipients.message_id;
-- attachments のリレーション
DEFINE FIELD attachments ON mail_messages TYPE array<record<mail_attachments>>;
RELATE mail_messages:attachments -> mail_attachments ON mail_messages.id = mail_attachments.message_id;

-- mail_senders と mail_contacts のリレーション
DEFINE FIELD contact ON mail_senders TYPE record<mail_contacts>;
RELATE mail_senders:contact -> mail_contacts ON   mail_senders.email = mail_contacts.id;
-- mail_recipients と mail_contacts のリレーション
DEFINE FIELD contact ON mail_recipients TYPE record<mail_contacts>;
RELATE mail_recipients:contact -> mail_contacts ON mail_recipients.email = mail_contacts.id;
