module aga::nft {
    use sui::url::{Self, Url};
    use sui::utf8;
    use sui::object::{Self, ID, Info};
    use sui::event;
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};

    struct MyNFT has key, store {
        info: Info,
        name: utf8::String,
        description: utf8::String,
        url: Url
    }

    struct NewNFT has copy, drop {
        object_id: ID,
        creator: address,
        name: utf8::String
    }

    public fun name(nft: &MyNFT): &utf8::String {
        &nft.name
    }

    public fun description(nft: &MyNFT): &utf8::String {
        &nft.description
    }

    public fun url(nft: &MyNFT): &Url {
        &nft.url
    }

    public entry fun create(
        name: vector<u8>,
        description: vector<u8>,
        url: vector<u8>,
        ctx: &mut TxContext
    ) {
        let sender = tx_context::sender(ctx);
        let info = object::new(ctx);
        let oid = *object::info_id(&info);
        let nft = MyNFT {
            info: info,
            name: utf8::string_unsafe(name),
            description: utf8::string_unsafe(description),
            url: url::new_unsafe_from_bytes(url)
        };

        event::emit(NewNFT {
            object_id: oid,
            creator: sender,
            name: nft.name,
        });

        transfer::transfer(nft, sender);
    }

    public entry fun transfer(
        nft: MyNFT, recipient: address, _: &mut TxContext
    ) {
        transfer::transfer(nft, recipient)
    }

    public entry fun update_description(
        nft: &mut MyNFT,
        new_description: vector<u8>,
        _: &mut TxContext
    ) {
        nft.description = utf8::string_unsafe(new_description)
    }
}