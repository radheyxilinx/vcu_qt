import QtQuick 2.0

Item {

    property int lowBitRate: 10000000
    property int mediumBitRate: 30000000
    property int highBitRate: 100000000

    property var presetStruct: [
        {"name":"HEVC Low", "bitrate":lowBitRate, "b_frame":2, "enc_name":"omxh264enc", "goP_len":30, "src":"v4l2src", "device_type":1},
        {"name":"HEVC Medium", "bitrate":mediumBitRate, "b_frame":2, "enc_name":"omxh264enc", "goP_len":30, "src":"v4l2src", "device_type":1},
        {"name":"HEVC High", "bitrate":highBitRate, "b_frame":2, "enc_name":"omxh264enc", "goP_len":30, "src":"v4l2src", "device_type":1},
        {"name":"AVC Low", "bitrate":lowBitRate, "b_frame":2, "enc_name":"omxh264enc", "goP_len":30, "src":"v4l2src", "device_type":1},
        {"name":"AVC Medium", "bitrate":mediumBitRate, "b_frame":2, "enc_name":"omxh264enc", "goP_len":30, "src":"v4l2src", "device_type":1},
        {"name":"AVC High", "bitrate":highBitRate, "b_frame":2, "enc_name":"omxh264enc", "goP_len":30, "src":"v4l2src", "device_type":1}
    ]
}
