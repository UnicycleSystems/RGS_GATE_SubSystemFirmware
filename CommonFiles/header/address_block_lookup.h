#ifndef ADDRESS_BLOCK_LOOKUP_H
#define ADDRESS_BLOCK_LOOKUP_H

#include <stdint.h>
#include <stdbool.h>

/**
  @Summary
    Looks up which block index a given address belongs to, by matching
    against the table of known block start addresses.

  @Param address
    The address to look up. Must exactly match a block's start address.

  @Param index_out
    On success, set to the matching entry's position in the
    block_start_address[] table (0, 1, 2, ...). Left unmodified on
    failure.

  @Return
    true if address matched a known block start, false otherwise.
*/
bool AddressBlock_Lookup(uint8_t address,uint8_t write_len, uint8_t *index_out);
bool GetAddressFromIndex(uint8_t index, uint8_t *address_out,uint8_t *block_len);

#endif // ADDRESS_BLOCK_LOOKUP_H
