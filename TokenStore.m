// 1. ฟังก์ชันสำหรับแปลง Token (NSData) ให้เป็น Hex String เพื่อนำไปใช้งานหรือจัดเก็บ
- (NSString *)tokenStringFromData:(NSData *)tokenData {
    if (tokenData == nil) {
        return nil;
    }
    
    NSUInteger dataLength = [tokenData length];
    if (dataLength == 0) {
        return @"";
    }

    const unsigned char *dataBuffer = (const unsigned char *)[tokenData bytes];
    if (dataBuffer == NULL) {
        return nil;
    }

    NSMutableString *hexString = [NSMutableString stringWithCapacity:(dataLength * 2)];
    for (NSUInteger i = 0; i < dataLength; ++i) {
        [hexString appendFormat:"%02x", dataBuffer[i]];
    }
    return [hexString copy];
}

// 2. ฟังก์ชันสำหรับบันทึก (Save) Token ลงในตัวเก็บข้อมูลภายในเครื่อง (เช่น NSUserDefaults) แบบด่วน
- (void)saveTokenData:(NSData *)tokenData withKey:(NSString *)key {
    if (tokenData == nil || key == nil) {
        return;
    }

    [[NSUserDefaults standardUserDefaults] setObject:tokenData forKey:key];
    // Removed synchronize for modern iOS versions
}

// 3. ฟังก์ชันสำหรับเตรียมส่ง Data/Token ผ่าน NSOutputStream (กรณีที่ต้องการเขียนลง Stream)
- (NSInteger)writeTokenData:(NSData *)tokenData toStream:(NSOutputStream *)outputStream {
    if (tokenData == nil || outputStream == nil) {
        return -1;
    }

    NSUInteger dataLength = [tokenData length];
    if (dataLength == 0) {
        return 0;
    }

    if (![outputStream hasSpaceAvailable]) {
        return -1;
    }

    const void *dataBuffer = [tokenData bytes];
    if (dataBuffer == NULL) {
        return -1;
    }

    NSInteger bytesWritten = [outputStream write:dataBuffer maxLength:dataLength];
    if (bytesWritten < 0) {
        NSLog(@"Error writing to stream: %@", [outputStream streamError]);
    }
    return bytesWritten;
}