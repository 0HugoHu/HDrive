import {Button, Center, Checkbox, Flex, Image, Input, useColorModeValue, VStack,} from "@hope-ui/solid"
import {createMemo, createSignal} from "solid-js"
import {useFetch, useRouter, useT, useTitle} from "~/hooks"
import {base_path, changeToken, handleRespWithoutNotify, hashPwd, notify, r,} from "~/utils"
import {Resp} from "~/types"
import LoginBg from "./LoginBg"
import {createStorageSignal} from "@solid-primitives/storage"
import {getSetting} from "~/store"

const Login = () => {
    const logos = getSetting("logo").split("\n")
    const logo = useColorModeValue(logos[0], logos.pop())
    const t = useT()
    const title = createMemo(() => {
        return `${t("login.login_to")} ${getSetting("site_title")}`
    })
    useTitle(title)
    const guestLoginButtonColor = useColorModeValue("$neutral1", "$neutral1")
    const [username, setUsername] = createSignal(
        localStorage.getItem("username") || "",
    )
    const [password, setPassword] = createSignal(
        localStorage.getItem("password") || "",
    )
    const [remember, setRemember] = createStorageSignal("remember-pwd", "false")
    const [loading, data] = useFetch(
        async (): Promise<Resp<{ token: string }>> => {
            return r.post("/auth/login/hash", {
                username: username(),
                password: hashPwd(password()),
            })
        },
    )

    const {searchParams, to} = useRouter()

    const Login = async () => {
        if (remember() === "true") {
            localStorage.setItem("username", username())
            localStorage.setItem("password", password())
        } else {
            localStorage.removeItem("username")
            localStorage.removeItem("password")
        }
        const resp = await data()
        handleRespWithoutNotify(
            resp,
            (data) => {
                notify.success(t("login.success"))
                changeToken(data.token)
                to(
                    decodeURIComponent(searchParams.redirect || base_path || "/"),
                    true,
                )
            },
            (msg) => {
                notify.error(msg)
            },
        )
    }

    return (
        <Center zIndex="1" w="$full" h="100vh">
            <VStack
                bgColor="#f7f8fa"
                rounded="$xl"
                p="24px"
                w={{
                    "@initial": "90%",
                    "@sm": "364px",
                }}
                spacing="$4"
            >
                <Flex direction="column" alignItems="center" justifyContent="space-around">
                    <Image mr="$2" width={{
                        "@initial": "50%"
                    }} height="auto" src={logo()}/>
                </Flex>
                <Input
                    name="username"
                    placeholder={t("login.username-tips")}
                    value={username()}
                    onInput={(e) => setUsername(e.currentTarget.value)}
                />
                <Input
                    name="password"
                    placeholder={t("login.password-tips")}
                    type="password"
                    value={password()}
                    onInput={(e) => setPassword(e.currentTarget.value)}
                    onKeyDown={(e) => {
                        if (e.key === "Enter") {
                            Login()
                        }
                    }}
                />
                <Flex
                    px="$1"
                    w="$full"
                    fontSize="$sm"
                    color="$neutral11"
                    justifyContent="space-between"
                    alignItems="center"
                >
                    <Checkbox
                        checked={remember() === "true"}
                        colorScheme="neutral"
                        onChange={() =>
                            setRemember(remember() === "true" ? "false" : "true")
                        }
                    >
                        {t("login.remember")}
                    </Checkbox>
                </Flex>
                <VStack
                    p="24px"
                    spacing="normal"
                    padding={0}
                ></VStack>
                <Button
                    w="$full"
                    colorScheme="neutral"
                    color="#f7f8fa"
                    bgColor="#333333"
                    _hover={{
                        bgColor: "#555",
                        color: "#fff"
                    }}
                    loading={loading()}
                    onClick={Login}
                >
                    {t("login.login")}
                </Button>
                <Button
                    w="$full"
                    colorScheme="neutral"
                    bgColor="#f7f8fa"
                    color="$neutral11"
                    onClick={() => {
                        changeToken()
                        to(
                            decodeURIComponent(searchParams.redirect || base_path || "/"),
                            true,
                        )
                    }}
                >
                    {t("login.use_guest")}
                </Button>
            </VStack>
            <LoginBg/>
        </Center>
    )
}

export default Login
