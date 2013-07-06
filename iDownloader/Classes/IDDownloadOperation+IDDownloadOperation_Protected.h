//
//  IDDownloadOperation+IDDownloadOperation_Protected.h
//  iDownloader
//
//  Created by iMac Asisiov on 06.07.13.
//  Copyright (c) 2013 Asisiov. All rights reserved.
//

#import "IDDownloadOperation.h"

/**
 IDDownloadOperation_Protected category contain protected methods which you may override.
 */

@interface IDDownloadOperation (IDDownloadOperation_Protected)

/// ---------------------------------------------------------------------------
/// @name Protected Methods
/// ---------------------------------------------------------------------------

/**  Method begin operation. You should be override this method. */
- (void)_start;

/**  Method finishing operation. You should be override this method. */
- (void)_finish;

/**  Method canceling operation. You should be override this method. */
- (void)_cancel;

/**  Method pausing operation. You should be override this method. */
- (void)_pause;

/**  Method resuming operation. You should be override this method. */
- (void)_resume;

/**  Method main operation. You should be override this method. */
- (void)_main;

@end
