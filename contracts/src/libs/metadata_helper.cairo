use starknet::ContractAddress;
use budokan::models::budokan::TokenType;
use budokan::interfaces::{
    IERC20MetadataFeltDispatcher, IERC20MetadataFeltDispatcherTrait, IERC721MetadataFeltDispatcher,
    IERC721MetadataFeltDispatcherTrait,
};
use openzeppelin_token::erc20::interface::{IERC20MetadataDispatcher, IERC20MetadataDispatcherTrait};
use openzeppelin_token::erc721::interface::{
    IERC721MetadataDispatcher, IERC721MetadataDispatcherTrait,
};
use budokan::libs::utils::U256BytesUsedTraitImpl;

/// Try to get token metadata, handling both ByteArray and felt252 returns
pub fn get_token_metadata(
    token_address: ContractAddress, token_type: TokenType,
) -> (ByteArray, ByteArray) {
    match token_type {
        TokenType::erc20 => {
            // First try standard ByteArray interface
            let metadata_dispatcher = IERC20MetadataDispatcher { contract_address: token_address };
            match try_get_erc20_metadata_bytearray(metadata_dispatcher) {
                Result::Ok((name, symbol)) => (name, symbol),
                Result::Err(_) => {
                    // Fall back to felt252 interface
                    let felt_dispatcher = IERC20MetadataFeltDispatcher {
                        contract_address: token_address,
                    };
                    let name_felt = felt_dispatcher.name();
                    let symbol_felt = felt_dispatcher.symbol();
                    (felt252_to_byte_array(name_felt), felt252_to_byte_array(symbol_felt))
                },
            }
        },
        TokenType::erc721 => {
            // First try standard ByteArray interface
            let metadata_dispatcher = IERC721MetadataDispatcher { contract_address: token_address };
            match try_get_erc721_metadata_bytearray(metadata_dispatcher) {
                Result::Ok((name, symbol)) => (name, symbol),
                Result::Err(_) => {
                    // Fall back to felt252 interface
                    let felt_dispatcher = IERC721MetadataFeltDispatcher {
                        contract_address: token_address,
                    };
                    let name_felt = felt_dispatcher.name();
                    let symbol_felt = felt_dispatcher.symbol();
                    (felt252_to_byte_array(name_felt), felt252_to_byte_array(symbol_felt))
                },
            }
        },
    }
}

/// Try to get ERC20 metadata as ByteArray
fn try_get_erc20_metadata_bytearray(
    dispatcher: IERC20MetadataDispatcher,
) -> Result<(ByteArray, ByteArray), felt252> {
    // Try to call the methods, they will panic if the return type doesn't match
    match starknet::syscalls::call_contract_syscall(
        dispatcher.contract_address, selector!("name"), array![].span(),
    ) {
        Result::Ok(ret_data) => {
            let mut ret_data_span = ret_data;
            match core::serde::Serde::<ByteArray>::deserialize(ref ret_data_span) {
                Option::Some(name) => {
                    // If name worked, try symbol
                    match starknet::syscalls::call_contract_syscall(
                        dispatcher.contract_address, selector!("symbol"), array![].span(),
                    ) {
                        Result::Ok(symbol_data) => {
                            let mut symbol_data_span = symbol_data;
                            match core::serde::Serde::<
                                ByteArray,
                            >::deserialize(ref symbol_data_span) {
                                Option::Some(symbol) => Result::Ok((name, symbol)),
                                Option::None => Result::Err('Failed to deserialize symbol'),
                            }
                        },
                        Result::Err(_) => Result::Err('Failed to call symbol'),
                    }
                },
                Option::None => Result::Err('Failed to deserialize name'),
            }
        },
        Result::Err(_) => Result::Err('Failed to call name'),
    }
}

/// Try to get ERC721 metadata as ByteArray
fn try_get_erc721_metadata_bytearray(
    dispatcher: IERC721MetadataDispatcher,
) -> Result<(ByteArray, ByteArray), felt252> {
    // Try to call the methods, they will panic if the return type doesn't match
    match starknet::syscalls::call_contract_syscall(
        dispatcher.contract_address, selector!("name"), array![].span(),
    ) {
        Result::Ok(ret_data) => {
            let mut ret_data_span = ret_data;
            match core::serde::Serde::<ByteArray>::deserialize(ref ret_data_span) {
                Option::Some(name) => {
                    // If name worked, try symbol
                    match starknet::syscalls::call_contract_syscall(
                        dispatcher.contract_address, selector!("symbol"), array![].span(),
                    ) {
                        Result::Ok(symbol_data) => {
                            let mut symbol_data_span = symbol_data;
                            match core::serde::Serde::<
                                ByteArray,
                            >::deserialize(ref symbol_data_span) {
                                Option::Some(symbol) => Result::Ok((name, symbol)),
                                Option::None => Result::Err('Failed to deserialize symbol'),
                            }
                        },
                        Result::Err(_) => Result::Err('Failed to call symbol'),
                    }
                },
                Option::None => Result::Err('Failed to deserialize name'),
            }
        },
        Result::Err(_) => Result::Err('Failed to call name'),
    }
}
/// Convert a felt252 to ByteArray
fn felt252_to_byte_array(value: felt252) -> ByteArray {
    let mut _bytearray_value = Default::default();
    if value != 0 {
        _bytearray_value
            .append_word(value, U256BytesUsedTraitImpl::bytes_used(value.into()).into());
    }
    _bytearray_value
}

