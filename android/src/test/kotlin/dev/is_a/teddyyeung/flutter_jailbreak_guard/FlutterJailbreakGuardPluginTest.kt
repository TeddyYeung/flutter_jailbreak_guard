package dev.is_a.teddyyeung.flutter_jailbreak_guard

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.mockito.Mockito
import kotlin.test.Test

internal class FlutterJailbreakGuardPluginTest {
    @Test
    fun onMethodCall_unknownMethod_returnsNotImplemented() {
        val plugin = FlutterJailbreakGuardPlugin()
        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)

        plugin.onMethodCall(MethodCall("unknown", null), mockResult)

        Mockito.verify(mockResult).notImplemented()
    }
}
