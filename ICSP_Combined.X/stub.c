/* Placeholder so this project has something to build.
 *
 * This project exists ONLY to programme a pre-built combined hex (bootloader +
 * application) from inside MPLAB X, without closing the IDE for IPE. The image
 * that actually reaches the device is set in
 *
 *     Project Properties -> Conf: [default] -> Loading
 *         "Load symbols/image from alternate file"  = ticked
 *         alternate file = ..\combined_<app>_BL<x>_APP<y>.hex
 *
 * so nothing in this file is programmed. It is here because a make project
 * needs at least one source to link.
 */
int main(void)
{
    for (;;)
    {
    }
}
