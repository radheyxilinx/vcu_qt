/******************************************************************************
 * (c) Copyright 2017 Xilinx, Inc. All rights reserved.
 *
 * This file contains confidential and proprietary information of Xilinx, Inc.
 * and is protected under U.S. and international copyright and other
 * intellectual property laws.
 *
 * DISCLAIMER
 * This disclaimer is not a license and does not grant any rights to the
 * materials distributed herewith. Except as otherwise provided in a valid
 * license issued to you by Xilinx, and to the maximum extent permitted by
 * applicable law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND WITH ALL
 * FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES AND CONDITIONS, EXPRESS,
 * IMPLIED, OR STATUTORY, INCLUDING BUT NOT LIMITED TO WARRANTIES OF
 * MERCHANTABILITY, NON-INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE;
 * and (2) Xilinx shall not be liable (whether in contract or tort, including
 * negligence, or under any other theory of liability) for any loss or damage
 * of any kind or nature related to, arising under or in connection with these
 * materials, including for any direct, or any indirect, special, incidental,
 * or consequential loss or damage (including loss of data, profits, goodwill,
 * or any type of loss or damage suffered as a result of any action brought by
 * a third party) even if such damage or loss was reasonably foreseeable or
 * Xilinx had been advised of the possibility of the same.
 *
 * CRITICAL APPLICATIONS
 * Xilinx products are not designed or intended to be fail-safe, or for use in
 * any application requiring fail-safe performance, such as life-support or
 * safety devices or systems, Class III medical devices, nuclear facilities,
 * applications related to the deployment of airbags, or any other applications
 * that could lead to death, personal injury, or severe property or
 * environmental damage (individually and collectively, "Critical
 * Applications"). Customer assumes the sole risk and liability of any use of
 * Xilinx products in Critical Applications, subject only to applicable laws
 * and regulations governing limitations on product liability.
 *
 * THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS PART OF THIS FILE
 * AT ALL TIMES.
 *******************************************************************************/

import QtQuick 2.0

Item {

    property int lowBitRate: 10000000
    property int mediumBitRate: 30000000
    property int highBitRate: 100000000

    property var presetStruct: [
        {"name":"HEVC Low", "bitrate":lowBitRate, "b_frame":2, "enc_enum":2, "enc_name":"omxh265enc", "goP_len":30, "src":"v4l2src", "device_type":1},
        {"name":"HEVC Medium", "bitrate":mediumBitRate, "b_frame":2, "enc_enum":2, "enc_name":"omxh265enc", "goP_len":30, "src":"v4l2src", "device_type":1},
        {"name":"HEVC High", "bitrate":highBitRate, "b_frame":2, "enc_enum":2, "enc_name":"omxh265enc", "goP_len":30, "src":"v4l2src", "device_type":1},
        {"name":"AVC Low", "bitrate":lowBitRate, "b_frame":2, "enc_enum":1, "enc_name":"omxh264enc", "goP_len":30, "src":"v4l2src", "device_type":1},
        {"name":"AVC Medium", "bitrate":mediumBitRate, "b_frame":2, "enc_enum":1, "enc_name":"omxh264enc", "goP_len":30, "src":"v4l2src", "device_type":1},
        {"name":"AVC High", "bitrate":highBitRate, "b_frame":2, "enc_enum":1, "enc_name":"omxh264enc", "goP_len":30, "src":"v4l2src", "device_type":1},
        {"name":"Custom", "bitrate":root.bitrate, "b_frame":root.b_frame, "enc_enum":root.enc_enum, "enc_name":root.enc_name, "goP_len":root.goP_len, "src":root.src, "device_type":root.device_type},
        {"name":"None", "bitrate":root.bitrate, "b_frame":root.b_frame, "enc_enum":root.enc_enum, "enc_name":root.enc_name, "goP_len":root.goP_len, "src":root.src, "device_type":root.device_type}
    ]
}
