#!/bin/sh
found=0

for home in /Users/*/; do
  user=$(basename "$home")

  for browser in "Google/Chrome" "Microsoft Edge"; do
    bname="Chrome"; echo "$browser" | grep -q "Edge" && bname="Edge"
    extbase="$home/Library/Application Support/$browser"
    [ -d "$extbase" ] || continue

    for profile in "$extbase/Default" "$extbase/Profile "*; do
      [ -d "$profile/Extensions" ] || continue

      for id in \
        kbfnbcaeplbcioakkpcpgfkobkghlhen \
        ofpnikijgfhlmmjlpkfaifhhdonchhoi \
        fgbpcgddpmkmaojgmlejhojmadmhdfhh \
        ldjkgaaoikpmhmkelcgkgacicjfbofhh \
        jgjaeacdkonaoafenlfkkkmbaopkbilf \
        bfhkfdnddlhfaodkeodfobimlhgfneca \
        inomeogfingihgjfjlpeplalcgfajhgai \
        obhmjnblpdfjlmgelejceabgjebjfnij \
        epjjgdpkmhmjcpgnhpfbfmhngeicggco \
        hhojmgelonhabbgckgfpchefmklhjnnb \
        gbhnoefbopijbgbpbdigdbblpigiamoc; do

        [ -d "$profile/Extensions/$id" ] || continue

        case "$id" in
          kbfnbcaeplbcioakkpcpgfkobkghlhen) name="Grammarly";;
          ofpnikijgfhlmmjlpkfaifhhdonchhoi) name="MaxAI.me";;
          fgbpcgddpmkmaojgmlejhojmadmhdfhh) name="Monica AI";;
          ldjkgaaoikpmhmkelcgkgacicjfbofhh) name="ChatGPT for Google";;
          jgjaeacdkonaoafenlfkkkmbaopkbilf)  name="Glasp AI";;
          bfhkfdnddlhfaodkeodfobimlhgfneca)  name="Merlin AI";;
          inomeogfingihgjfjlpeplalcgfajhgai) name="Perplexity AI";;
          obhmjnblpdfjlmgelejceabgjebjfnij)  name="Copilot in Edge";;
          epjjgdpkmhmjcpgnhpfbfmhngeicggco)  name="Compose AI";;
          hhojmgelonhabbgckgfpchefmklhjnnb)  name="Tactiq AI";;
          gbhnoefbopijbgbpbdigdbblpigiamoc)  name="Scribe AI";;
          *) name="Unknown";;
        esac

        printf "%s|%s|%s|%s\n" "$name" "$bname" "$id" "$user"
        found=1
      done
    done
  done
done

[ "$found" -eq 0 ] && echo "[No AI Extensions Found]"