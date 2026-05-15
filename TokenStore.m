// 1. ฟังก์ชันสำหรับแปลง Token (NSData) ให้เป็น Hex String เพื่อนำไปใช้งานหรือจัดเก็บ
- (NSString *)tokenStringFromData:(NSData *)tokenData {
    const unsigned char *dataBuffer = (const unsigned char *)[tokenData bytes];
    if (!dataBuffer) {
        return nil;
    }
    
    NSUInteger dataLength = [tokenData length];
    NSMutableString *hexString = [NSMutableString stringWithCapacity:(dataLength * 2)];
    for (int i = 0; i < dataLength; ++i) {
        [hexString appendFormat:@"%02x", dataBuffer[i]];
    }
    return [hexString copy];
}

// 2. ฟังก์ชันสำหรับบันทึก (Save) Token ลงในตัวเก็บข้อมูลภายในเครื่อง (เช่น NSUserDefaults) แบบด่วน
- (void)saveTokenData:(NSData *)tokenData withKey:(NSString *)key {
    if (tokenData) {
        [[NSUserDefaults standardUserDefaults] setObject:tokenData forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

// 3. ฟังก์ชันสำหรับเตรียมส่ง Data/Token ผ่าน NSOutputStream (กรณีที่ต้องการเขียนลง Stream)
- (NSInteger)writeTokenData:(NSData *)tokenData toStream:(NSOutputStream *)outputStream {
    if ([outputStream hasSpaceAvailable]) {
        NSInteger bytesWritten = [outputStream write:[tokenData bytes] maxLength:[tokenData length]];
        return bytesWritten;
    }
    return -1;
}
