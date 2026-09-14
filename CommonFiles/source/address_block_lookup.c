#include "../header/address_block_lookup.h"
#include "../header/EEpromBlockLabels.h"
// Each #define IS the block's start address or length. The
// block_start_address[] / block_length[] tables below are built
// directly from these, so the tables can never drift apart from each
// other -- add a block by adding two lines here (address and length)
// and one line in each table immediately below.


// Table of known block start addresses, built directly from the defines above.
static const uint8_t block_start_address[] =
{
    ConfigLasersAddr,
    SetIRLevelAddr,
    SetTicksPerSecond,
    SetModeChange,
    ConfigAccelerometerAddr,
    GeneralPurposeJobBufferAddr,
    ResetSubsysAddr,
    ResetSubsysConfirmAddr,
    JetsonCallingCode_Addr,
    JetsonAcknowledgeCall_Addr
};

// Table of block lengths, in the same order as block_start_address[] above.
static const uint8_t block_length[] =
{
    ConfigLasersNumBytes,
    SetIRLevelNumBytes,
    SetTicksPerSecondNumBytes,
    SetModeChangeNumBytes,
    ConfigAccelerometerNumBytes,
    GeneralPurposeJobBufferNumBytes,
    ResetSubsysNumBytes,
    ResetSubsysConfirmNumBytes,
    JetsonCallingCodeNumBytes,
    JetsonAcknowledgeNumBytes
};

#define NUM_BLOCKS 10

bool AddressBlock_Lookup(uint8_t address,uint8_t write_len, uint8_t *index_out)
{
    uint8_t i;

    for (i = 0; i < NUM_BLOCKS; i++)
    {
        if ((block_start_address[i] == address)&&(write_len == block_length[i]))
        {

            *index_out = i;
            return true;
            
        }
    }

    return false;
}

bool GetAddressFromIndex(uint8_t index, uint8_t *address_out,uint8_t *block_len)
{
    if(index>NUM_BLOCKS)
        return false;
   *address_out=block_start_address[index];
   *block_len=block_length[index];
   return true;
   
}

