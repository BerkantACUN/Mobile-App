<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

require 'vendor/autoload.php'; 
use Firebase\JWT\JWT;
use Firebase\JWT\Key;

$db = new mysqli("localhost", "root", "", "isitme_engelli_db");

if ($db->connect_error) {
    die(json_encode(["error" => "Veritabanı bağlantı hatası"]));
}

$secretKey = "gizli_anahtar"; // JWT için güvenli bir key

// Kullanıcı Kayıt
if ($_SERVER['REQUEST_METHOD'] === 'POST' && $_GET['action'] === 'register') {
    $data = json_decode(file_get_contents("php://input"), true);
    $username = $data['username'];
    $password = password_hash($data['password'], PASSWORD_BCRYPT);

    $stmt = $db->prepare("INSERT INTO users (username, password) VALUES (?, ?)");
    $stmt->bind_param("ss", $username, $password);
    $stmt->execute();
    echo json_encode(["message" => "Kullanıcı kaydedildi"]);
}

// Kullanıcı Giriş ve JWT Oluşturma
if ($_SERVER['REQUEST_METHOD'] === 'POST' && $_GET['action'] === 'login') {
    $data = json_decode(file_get_contents("php://input"), true);
    $username = $data['username'];
    $password = $data['password'];

    $stmt = $db->prepare("SELECT id, password FROM users WHERE username = ?");
    $stmt->bind_param("s", $username);
    $stmt->execute();
    $result = $stmt->get_result();
    $user = $result->fetch_assoc();

    if ($user && password_verify($password, $user['password'])) {
        $payload = [
            "user_id" => $user['id'],
            "username" => $username,
            "exp" => time() + 3600, // 1 saat geçerli
        ];
        $jwt = JWT::encode($payload, $secretKey, 'HS256');
        echo json_encode(["token" => $jwt]);
    } else {
        echo json_encode(["error" => "Geçersiz kullanıcı adı veya şifre"]);
    }
}

// JWT Doğrulama
function verifyJWT($token) {
    global $secretKey;
    try {
        return JWT::decode($token, new Key($secretKey, 'HS256'));
    } catch (Exception $e) {
        return null;
    }
}

// WebRTC Signaling
if ($_SERVER['REQUEST_METHOD'] === 'POST' && $_GET['action'] === 'offer') {
    $headers = apache_request_headers();
    $token = $headers['Authorization'] ?? '';
    $decoded = verifyJWT(str_replace('Bearer ', '', $token));
    
    if (!$decoded) {
        echo json_encode(["error" => "Yetkilendirme başarısız"]);
        exit;
    }
    
    $data = json_decode(file_get_contents("php://input"), true);
    $sdp = $data['sdp'];
    $type = $data['type'];
    
    // WebRTC Offer işlemleri burada işlenecek
    echo json_encode(["message" => "Offer alındı", "sdp" => $sdp, "type" => $type]);
}
?>
